-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m08a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[5] = 0 -- $PERFORMANCE_PROGRESS_LIST[5] = 0 (ROM)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Good. ♪ You appear to be in full\nreadiness. ♪", french="Bien. ♪ Vous avez apparemment\nfini vos préparatifs. ♪", german="Gut. ♪ Ihr scheint vorbereitet\nzu sein. ♪", italian="Bene. ♪ Sembra tutto\npronto. ♪", spanish="Estupendo. ♪ Veo que\nya os habéis preparado del todo. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="When the other apprentices\nassemble, I shall commence the briefing.\nUntil then, just wait. ♪", french="Quand les autres apprentis\nseront là, je commencerai la réunion.\nAttendez ici. ♪", german="Wenn die anderen Lehrlinge\neintreffen, werde ich die Besprechung\nbeginnen. Wartet bis dahin einfach. ♪", italian="La riunione inizierà quando\nsaranno arrivati gli altri apprendisti.\nPer il momento, aspettate. ♪", spanish="Cuando lleguen los demás\naprendices me dirigiré a todos.\nHasta entonces, tendréis que esperar. ♪"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30)
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" All accounted for, it appears.", french="On dirait que tout le monde\nest là.", german="Wie ich sehe, sind nun alle\nstartbereit.", italian=" Siete tutti qui, a quanto sembra.", spanish="Bueno, parece que ya estamos\ntodos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well then. Let me explain\nabout this expedition. ♪", french="Bien. Je vais donc vous\nexpliquer le déroulement de l'expédition. ♪", german="Nun gut. Lasst mich erklären,\nworum es bei der Expedition geht. ♪", italian="Bene. Allora lasciate che\nvi spieghi i dettagli di questa spedizione. ♪", spanish="Ya puedo hablaros de\nla expedición. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="First, the objective: exploration\nof [CS:P]Fogbound Lake[CR].", french="Premièrement, l'objectif:\nl'exploration du [CS:P]Lac des Brumes[CR].", german="Erstens, das Ziel: Die Erkundung\ndes [CS:P]Nebelsees[CR].", italian="In primo luogo, l'obiettivo:\nl'esplorazione del [CS:P]Lago Foschia[CR].", spanish="Lo primero, el objetivo.\nExploraremos el [CS:P]Lago Velado[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:P]Fogbound Lake[CR]?", french=" Le [CS:P]Lac des Brumes[CR]?", german=" Der [CS:P]Nebelsee[CR]?", italian=" [CS:P]Lago Foschia[CR]?", spanish=" ¿El [CS:P]Lago Velado[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:P]Fogbound Lake[CR]?", french=" Le [CS:P]Lac des Brumes[CR]?", german=" Der [CS:P]Nebelsee[CR]?", italian=" [CS:P]Lago Foschia[CR]?", spanish=" ¿El [CS:P]Lago Velado[CR]?"})
  else
  SkySceneKit.say({english=" [CS:P]Fogbound Lake[CR]?", french=" Le [CS:P]Lac des Brumes[CR]?", german=" Der [CS:P]Nebelsee[CR]?", italian=" [CS:P]Lago Foschia[CR]?", spanish=" ¿El [CS:P]Lago Velado[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Correct. It is a lake that is said\nto be located far to the east.", french="Exact. On raconte que ce lac\nse trouve loin à l'est.", german="Richtig. Dieser See soll sehr\nweit im Osten liegen.", italian="Esatto. È un lago che si\ntrova ad est, lontano da qui.", spanish="Correcto. Parece ser que es un lago\nque está al este, bastante alejado."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="However, it is perpetually\nenshrouded by a dense fog. As such, its actual\nexistence has never been confirmed...", french="En outre, il est perpétuellement\nenveloppé dans un brouillard dense. De fait,\nson existence n'a jamais été confirmée...", german="Er ist jedoch ständig von einem\ndichten Nebel umhüllt. Daher wurde seine\nExistenz niemals nachgewiesen.", italian="Tuttavia, è perennemente\navvolto in una fitta nebbia. Per questo motivo,\nla sua esistenza non è mai stata confermata...", spanish="Según cuentan, está rodeado por una\ndensa niebla casi impenetrable. Por ello, no\nse sabe a ciencia cierta si existe realmente."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It is merely the foggy mirage of\na spot that lives to this day on rumor alone.", french="Tel un mirage nimbé de brume,\ncet endroit ne serait donc qu'une légende.", german="Er ist lediglich eine nebelhafte\nVorstellung eines Ortes, die sich bis heute\neinzig und allein auf Gerüchte stützt.", italian="Esistono semplicemente delle\nvoci in merito.", spanish="Hay quien dice que en el fondo son\nsolo habladurías."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" It is also rumored...", french=" On raconte aussi...", german=" Es gibt da auch ein Gerücht...", italian=" E c'è di più...", spanish=" Aunque otros aseguran..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="A treasure of exquisite beauty\nis hidden there! ♪", french="... qu'il recèle un trésor d'une\nindicible beauté! ♪", german="Man sagt, dort soll ein Schatz\nvon atemberaubender Schönheit versteckt\nsein! ♪", italian="Si dice anche che il lago\nnasconda un tesoro di una bellezza senza\npari! ♪", spanish="¡Que allí se oculta un tesoro\nde exquisita belleza! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wow! Treasure?! We're going\non a treasure hunt!", french="Wouah! Un trésor?! On part\nà la chasse au trésor!", german="Wow! Ein Schatz?!? Wir gehen\nauf Schatzjagd!", italian="Wow! Un tesoro?! Andiamo\na caccia di tesori!", spanish="¡Vaya! ¡¿Un tesoro?!\n¡Vamos a buscar un tesoro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow! Treasure?! We're going\non a treasure hunt!", french="Wouah! Un trésor?! On part\nà la chasse au trésor!", german="Wow! Ein Schatz?!? Wir gehen\nauf Schatzjagd!", italian="Wow! Un tesoro?! Andiamo\na caccia di tesori!", spanish="¡Vaya! ¡¿Un tesoro?!\n¡Vamos a buscar un tesoro!"})
  else
  SkySceneKit.say({english="Wow! Treasure?! We're going\non a treasure hunt!", french="Wouah! Un trésor?! On part\nà la chasse au trésor!", german="Wow! Ein Schatz?!? Wir gehen\nauf Schatzjagd!", italian="Wow! Un tesoro?! Andiamo\na caccia di tesori!", spanish="¡Vaya! ¡¿Un tesoro?!\n¡Vamos a buscar un tesoro!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This is so exciting!", french=" Je brûle d'impatience!", german=" Das ist ja so aufregend!", italian=" È così emozionante!", spanish=" ¡Qué emocionante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This is so exciting!", french=" Je brûle d'impatience!", german=" Das ist ja so aufregend!", italian=" Che emozione!", spanish=" ¡Qué emocionante!"})
  else
  SkySceneKit.say({english=" This is so exciting!", french=" Je brûle d'impatience!", german=" Das ist ja so aufregend!", italian=" Sono così emozionata!", spanish=" ¡Qué emocionante!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yup! It will be fun, fun, fun! ♪", french="Yep! Ça va être rigolo, rigolo,\nrigolo! ♪", german="Ja! Es wird ein riesen-, riesen-,\nriesengroßer Spaß! ♪", italian=" Già! Sarà divertentissimo! ♪", spanish="¡Sí! ¡Será superdíver!\n¡Chachi, chachi! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 336, 232, Direction.Right, "NPC_SUKATANKU")
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" (Chaw-haw-haw.)", french="(Tu l'as dit, bouffi... Gnark\ngnark gnark!)", german=" (Cha-ha-ha.)", italian=" (Ahr-ahr-ahr.)", spanish=" (Jua, jua, jua.)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone, open your Wonder\nMaps, please.", french="Ouvrez tous votre Carte\nMiracle, s'il vous plaît.", german="Macht bitte alle eure\nWunderkarten auf.", italian="Gente, tirate fuori le vostre\nMappe delle meraviglie, per favore.", spanish="Abrid todos vuestro Mapa Mágico,\npor favor."})
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
