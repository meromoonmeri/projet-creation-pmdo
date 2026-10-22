-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D09P11A/m10a0904.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D09P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_RAIN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 256, 400, Direction.Up, "NPC_HEIGANI")
  GROUND:MoveToPosition(npc_npc_heigani, 252, 236, false, 2)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 288, 416, Direction.Up, "NPC_KIMAWARI")
  GROUND:MoveToPosition(npc_npc_kimawari, 288, 252, false, 2)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 216, 416, Direction.Up, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 216, 244, false, 2)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 288, 448, Direction.Up, "NPC_CHIRIIN")
  GROUND:MoveToPosition(npc_npc_chiriin, 288, 284, false, 2)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 240, 440, Direction.Up, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 240, 264, false, 2)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 216, 448, Direction.Up, "NPC_DOGOOMU")
  GROUND:MoveToPosition(npc_npc_dogoomu, 212, 268, false, 2)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 256, 424, Direction.Up, "NPC_GUREGGURU")
  GROUND:MoveToPosition(npc_npc_guregguru, 264, 260, false, 2)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 264, 464, Direction.Up, "NPC_DAGUTORIO")
  GROUND:MoveToPosition(npc_npc_dagutorio, 264, 284, false, 2)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 232, 480, Direction.Up, "NPC_DIGUDA")
  GROUND:MoveToPosition(npc_npc_diguda, 232, 284, false, 2)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- se_FadeOut(6916, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! There's the way in!", french=" Eh dis donc, voilà l'entrée!", german=" Hey, hey! Da ist der Eingang!", italian=" Ehi, ehi! Ecco un'entrata!", spanish=" ¡Oye, oye! ¡Esa es la entrada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" We can go up through here!", french=" On peut monter par là!", german=" Hier können wir hineingehen!", italian=" Passando di qua si può salire!", spanish=" ¡Podemos subir por ahí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Let's HURRY!", french=" Hop hop hop, on se DEPECHE!", german=" Los, BEEILUNG!", italian=" MUOVIAMOCI!", spanish=" ¡Démonos prisa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_heigani, 252, 204, false, 2)
  GAME:WaitFrames(2)
  GROUND:MoveToPosition(npc_npc_perappu, 252, 204, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_kimawari, 252, 204, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_guregguru, 252, 204, false, 2)
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_bippa, 252, 204, false, 2)
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_dogoomu, 252, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 252, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_diguda, 252, 204, false, 2)
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_dagutorio, 252, 204, false, 2)
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(180) end)
  -- se_FadeOut(6916, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(90)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" H...h...hey...", french=" Eh...", german=" H-h-hey...", italian=" E... e... ehi...", spanish=" O... oye..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="H...hey...[CS:N]Chatot[CR]![K] Can I ask you\nsomething while we're running?", french="... eh dis donc... [CS:N]Pijako[CR]![K]\nJe peux te poser une question pendant\nqu'on court?", german="H-hey, [CS:N]Plaudagei[CR]![K] Kann ich etwas\nfragen, während wir weiterlaufen?", italian="E... ehi... [CS:N]Chatot[CR]![K] Posso\nchiederti una cosa?", spanish="O... oye... ¡[CS:N]Chatot[CR]![K] ¿Te puedo\npreguntar una cosa mientras corremos?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR], do you know about a\nPokémon called [CS:N]Groudon[CR]?", french="[CS:N]Pijako[CR], tu as déjà entendu parler\nd'un Pokémon appelé [CS:N]Groudon[CR]?", german="[CS:N]Plaudagei[CR], kennst du ein\nPokémon namens [CS:N]Groudon[CR]?", italian="[CS:N]Chatot[CR], tu lo conosci un Pokémon\nche si chiama [CS:N]Groudon[CR]?", spanish="[CS:N]Chatot[CR], ¿has oído hablar de un\nPokémon llamado [CS:N]Groudon[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well, of course! Just what do\nyou take me for? I'm only the head of\nintelligence for our guild![K] Squawk!", french="Bien entendu! Pour qui me\nprends-tu? Ne suis-je pas le chef des services\nde renseignements de la Guilde?[K] Couac!", german="Aber natürlich! Für wen hältst\ndu mich? Ich bin immerhin das oberste\nDenkorgan der Gilde![K] Kreisch!", italian="Ma certo! Naturalmente! Per chi\nmi hai preso? Dimentichi forse che sono il\ngazzettino della Gilda?[K] Squack!", spanish="¡Por supuesto! ¿Por quién me\ntomas? ¿Acaso no soy el cerebro de las\noperaciones del [CS:N]Pokégremio[CR]?[K] ¡Cruac!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Groudon[CR] is a legendary\nPokémon spoken of in myths passed down\nthrough generations.", french="[CS:N]Groudon[CR] est un Pokémon\nlégendaire dont parlent les mythes transmis\nde génération en génération.", german="[CS:N]Groudon[CR] ist ein legendäres\nPokémon, von dem in Mythen die Rede ist, die\nseit Generationen weitergegeben werden.", italian="[CS:N]Groudon[CR] è un Pokémon\nleggendario. Ci sono storie che parlano di lui\nche vengono tramandate ormai da generazioni.", spanish="[CS:N]Groudon[CR] es un Pokémon\nlegendario del que se habla en mitos\ntransmitidos de una generación a otra."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" A legendary Pokémon?", french=" Un Pokémon légendaire?", german=" Ein legendäres Pokémon?", italian=" Un Pokémon leggendario?", spanish=" ¿Un Pokémon legendario?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Correct.", french=" Exact.", german=" Richtig.", italian=" Esattamente.", spanish=" Correcto."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The myths say that he raised\nland from the sea. And that he built up the\ncontinents!", french="La légende raconte que c'est lui\nqui a fait émerger les terres du fond\ndes mers, et qu'il a ainsi créé les continents!", german="In den Mythen heißt es, dass es\ndas Land aus dem Meer gehoben hat. Und dass\nes die Kontinente gebaut hat!", italian="Si narra nelle leggende...[K] che\nlui abbia fatto emergere la terra dagli\noceani...[K] e che abbia creato i continenti!", spanish="Según se cuenta hizo surgir\nla tierra de debajo del mar. Y creó, así,\nlos continentes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hoo-boy! That sounds like a\ncolossal Pokémon!", french="Bigre! Ça doit être un colosse,\nce Pokémon!", german="Huiuiui! Das hört sich nach\neinem enormen Pokémon an!", italian="Uao! Quello sì che dev'essere\nun mega-Pokémon!", spanish="¡Oye, oye! ¡Entonces tiene que\nser un Pokémon colosal!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
