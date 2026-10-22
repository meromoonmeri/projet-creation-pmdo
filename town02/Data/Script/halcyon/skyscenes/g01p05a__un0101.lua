-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05A/un0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  if ((SV.SkyTalkBitFlags or {})[131] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[131]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 208, 200, Direction.Up, "NPC_PUKURIN")
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="S-sorry...[K]\nIt's nothing.", french="Pa... pardon...[K]\nCe n'est rien.", german="T-tut mir leid...[K]\nEs ist gar nichts.", italian=" S-Scusa...[K] Non è niente.", spanish="Pe... perdona...[K]\nNo es nada."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Have fun on your\nexploration! ♪", french="Amuse-toi bien pendant\nton exploration! ♪", german="Viel Spaß auf deiner\nErkundung! ♪", italian="Divertiti durante\nla tua esplorazione! ♪", spanish="¡Que te lo pases bien\nexplorando! ♪"})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[131] = 1 -- $SCENARIO_TALK_BIT_FLAG[131] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_ExecuteCommon(CORO_EVENT_N00_01) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp_side(40, 3) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Having fun on your day off?", french="Alors, ces vacances?\nTu t'amuses?", german=" Genießt du deine freie Zeit?", italian=" Ti stai divertendo in vacanza?", spanish="¿Te lo pasas bien\nen tu día libre?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="If you're going to take a day off,\nmake it a memorable one! La-la-la! ♪", french="Si tu prends des vacances, fais\nen sorte qu'elles soient mémorables!\nTralala! ♪", german="Wenn du ein Weilchen\nfreinimmst, mach etwas Erinnerungswürdiges!\nLa-la-la! ♪", italian="Se hai intenzione di prenderti\nalcuni giorni liberi, cerca di viverli\nalla grande! Lallalà! ♪", spanish="Si te vas a tomar vacaciones,\nhaz que sean memorables. ¡La, la, la! ♪"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I've heard... ♪", french=" Il paraît... ♪", german=" Ich habe da etwas gehört... ♪", italian=" Ho saputo... ♪", spanish=" Por lo que he oído... ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You are taking a day off?[K]\nSounds like fun, fun, fun! ♪", french="... que tu es en vacances?[K]\nÇa a l'air drôlement chouette! ♪", german="Du hast ein Weilchen\nfreibekommen?[K] Klingt nach riesen-,\nriesengroßem Spaß! ♪", italian="... che ti prendi qualche giorno\nlibero.[K] Sarà uno spasso spassosissimo! ♪", spanish="¿Te vas a tomar vacaciones?[K]\n¡Suena requetedivertido! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Really, I'd like to take a day\noff to go searching for Perfect Apples...", french="Vrai de vrai, j'adorerais\nprendre un jour de congé pour\naller chercher des Pommes Parfaites...", german="Wirklich, ich würde gerne einen\nTag freihaben, um Perfekte Äpfel suchen zu\nkönnen...", italian="Anch'io vorrei tanto prendermi\nun giorno di vacanza e andare a cercare\ndelle Mele Perfette...", spanish="A mí me encantaría tener tiempo\nlibre para ir a coger Manzanas Perfectas..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" But...[K][CS:N]Chatot[CR]...", french=" Mais... [K][CS:N]Pijako[CR]...", german=" Aber... [K][CS:N]Plaudagei[CR]...", italian=" Ma...[K][CS:N] Chatot[CR]...", spanish=" Pero...[K] [CS:N]Chatot[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR] doesn't let me...[K] Sniff...", french="[CS:N]Pijako[CR] n'acceptera jamais...\n[K]Snif...", german="[CS:N]Plaudagei[CR] lässt mich nicht...[K]\nSchnüff...", italian=" [CS:N]Chatot[CR] non mi lascia...[K] Sniff...", spanish=" [CS:N]Chatot[CR] no me deja...[K] Jo..."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="How is it living at the guild?[K]\nAre you getting used to it?", french="Comment se passe la vie\nà la Guilde?[K]\nTu t'y fais?", german="Wie lebt es sich in der Gilde?[K]\nHast du dich gut eingewöhnt?", italian="Come ti trovi qui alla Gilda?[K]\nTi stai abituando?", spanish="¿Se vive bien en el [CS:N]Pokégremio[CR]?[K]\n¿Te cuesta mucho adaptarte?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It must be difficult, having just\njoined...", french="Ça ne doit pas être facile\nquand on vient juste d'arriver...", german="Es muss schwierig sein, gerade\nerst dazugekommen zu sein.", italian="Non deve essere facile,\nd'altronde sei appena arrivato...", spanish="Tiene que ser dificilillo, como\nacabas de llegar..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Work hard, so you can soon\nbecome a first-rate explorer! ♪", french="Travaille dur, pour devenir\nun jour un explorateur de premier ordre! ♪", german="Streng dich an, dann wirst du\nschon bald zu einem erstklassigen Erkunder! ♪", italian="Lavora sodo, così presto\ndiventerai un esploratore di prima\ncategoria! ♪", spanish="¡Trabaja duro para llegar a\nexplorar como los mejores! ♪"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
