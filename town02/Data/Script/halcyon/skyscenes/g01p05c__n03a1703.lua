-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05C/n03a1703.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_G01P05C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(10) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_FIRE_CRACKLING3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 224, 232, Direction.UpRight, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I see...", french=" Je vois...", german=" Verstehe...", italian=" Capisco...", spanish=" Entiendo..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The story of your exploration\ngoes back all the way back to your childhood...", french="Toute cette histoire remonte à\nvotre prime enfance...", german="Du hast also schon als Kind mit\ndem Erkunden angefangen...", italian="Questa storia risale ai tempi\ndella sua infanzia, Capitano...", spanish="Tu historia como explorador\nse remonta hasta tu infancia..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 240, 216, Direction.DownLeft, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yes.[K] That's why this\n[CS:Z]Defend Globe[CR] is my starting point.", french="Oui.[K] C'est avec cette\n[CS:Z]Défensphère[CR] que tout a commencé.", german="Ja.[K] Deswegen ist dieser\n[CS:Z]Abwehrglobus[CR] mein Grundstein.", italian="Sì.[K] Ecco perché questo\n[CS:Z]Globodifesa[CR] rappresenta il mio punto\ndi partenza.", spanish="Sí.[K] Por eso este [CS:Z]Globodefensa[CR]\nes mi punto de partida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="...[K]And, Guildmaster,\nyour Master...", french="...[K] Et Maître, votre Maître\nà vous...", german="...[K]Und was passierte mit\ndeinem Meister, Gildenmeister?", italian=" ...[K] Capitano... E il suo maestro?", spanish=" Y...[K] tu maestro, Gran Bluff..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="After that, what happened\nto him?", french="... après cela, que lui\nest-il arrivé?", german="Seid ihr danach wieder\nzusammen auf Erkundungen gegangen?", italian=" Dopo cosa gli è successo?", spanish=" Después de aquello, ¿qué fue de él?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Oh, many things\nhappened to him. After all...", french="Oh, bien des choses lui\nsont arrivées. En définitive...", german="Oh, er hat noch eine\nMenge erlebt.", italian="Oh, gli sono capitate tante cose.\nDopotutto...", spanish="Ah, le sucedieron muchas cosas.\nDespués de todo..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" He is my only Master. ♪", french="Il aura été mon seul et\nunique Maître. ♪", german="Es hat schon seinen Grund, dass\ner mein einziger Meister ist. ♪", italian="... è il mio solo e unico\nmaestro. ♪", spanish=" Es mi único maestro. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We'll save those stories for\nanother time. ♪[K] I'm too tired for more today.", french="Mais gardons la suite pour\nune autre fois. ♪[K] Je suis trop fatigué\npour en raconter plus aujourd'hui.", german="Aber heben wir uns diese\nGeschichten lieber für ein anderes Mal auf. ♪[K]\nHeute bin ich dafür zu erschöpft.", italian="Ma ne parleremo la prossima\nvolta. ♪[K] Ora sono troppo stanco.", spanish="Mejor guardamos esas historias\npara otro momento. ♪[K] Hoy estoy demasiado\ncansado."})
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You know...[K] Whenever I look at\nthis [CS:Z]Defend Globe[CR], I think of him.", french="Tu sais...[K] Dès que je regarde\ncette [CS:Z]Défensphère[CR], je pense à lui.", german="Weißt du...[K] Immer wenn ich\ndiesen [CS:Z]Abwehrglobus[CR] betrachte, denke ich\nan ihn.", italian="Sai...[K] Ogni volta che guardo\nquesto [CS:Z]Globodifesa[CR], ripenso a lui.", spanish="¿Sabes...?[K] Siempre que miro\neste [CS:Z]Globodefensa[CR] pienso en él."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It's my starting point in\nbecoming an explorer.", french="C'est le point de départ de tout,\nce qui a fait que je suis devenu explorateur.", german="Das ist der Grundstein meiner\nKarriere als Erkunder.", italian="È il mio punto di partenza\ncome esploratore.", spanish="Así fue como empezó mi\nandadura como explorador."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" And...", french=" Et...", german=" Und...", italian=" E...", spanish=" Y..."})
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]Of course, there are lots of\n[CN]outlaws in this world...", french="[CN]Bien sûr, il y a bien des\n[CN]hors-la-loi en ce monde...", german="[CN]Sicherlich gibt es eine Menge\n[CN]Ganoven in dieser Welt...", italian="[CN]Naturalmente ci sono molti\n[CN]ricercati in questo mondo...", spanish="[CN]Por supuesto, hay montones\n[CN]de malhechores en este mundo..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]They are caught and punished, but...", french="[CN]On les attrape et on les condamne, mais...", german="[CN]Sie werden gefangen und bestraft, aber...", italian="[CN]Che vengono catturati e puniti, ma...", spanish="[CN]Se les captura y castiga, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]But...", french="[CN]... au final...", german="[CN]Aber...", italian="[CN]Ma...", spanish="[CN]En realidad..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]Truly bad Pokémon...", french="[CN]... les Pokémon foncièrement mauvais...", german="[CN]Wirklich böse Pokémon...", italian="[CN]Pokémon davvero cattivi...", spanish="[CN]Los Pokémon malos de verdad..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]Don't really exist anywhere.", french="[CN]... n'existent pas vraiment.", german="[CN]Die existieren gar nicht.", italian="[CN]Non ne esistono.", spanish="[CN]No existen en ningún sitio."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
