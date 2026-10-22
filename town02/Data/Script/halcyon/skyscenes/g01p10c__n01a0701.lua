-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P10C/n01a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_G01P10C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 264, 200, Direction.Down, "NPC_DOGOOMU")
  -- SetAnimation(44) [anim idle native]
  GAME:WaitFrames(10)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 176, 200, Direction.Down, "NPC_HEIGANI")
  -- SetAnimation(45) [anim idle native]
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Phew...[K] Today was a really long\nday, yup yup...", french="Pfiou...[K] Quelle journée,\nmais quelle journée, mes aïeux!", german="Puh...[K] Heute war ein wirklich\nlanger Tag, jawollja.", italian="Uff...[K] Oggi è stata una giornata\ndavvero faticosa, già, già...", spanish="Buf...[K] Hoy ha sido un día\nlarguísimo, sí, señor..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Those two are already asleep.", french=" Ces deux-là roupillent déjà.", german=" Die beiden schlafen schon.", italian="Quei due si sono già\naddormentati.", spanish=" Estos dos ya están durmiendo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'll have to get up early\ntomorrow...[K] Guess I should probably get to bed\ntoo, yup yup.", french="Faudra qu'je m'lève tôt demain...[K]\nJ'ferais mieux de dormir moi aussi,\ndu coup, ouaip.", german="Morgen muss ich früh raus...[K]\nIch sollte auch so schnell wie möglich\nRuhe finden, jawollja.", italian="Devo svegliarmi presto domani...[K]\nForse è meglio che dorma anch'io, già, già.", spanish="Mañana tendré que levantarme\ntemprano...[K] Supongo que yo también\ndebería irme a dormir, sí, señor."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Good night, you all.", french=" Bonne nuit, tout l'monde.", german=" Gute Nacht, allerseits.", italian=" Buonanotte a tutti.", spanish=" Buenas noches a todos."})
  -- message_Close
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(46) [anim idle native]
  GAME:WaitFrames(120)
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]A few minutes later...", french="[CN]Quelques minutes plus tard...", german="[CN]Einige Minuten später...", italian="[CN]Qualche minuto dopo...", spanish="[CN]Unos minutos después..."})
  -- message_Close
  GAME:WaitFrames(45)
  -- GAP: se_Play(9217) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" GOOOOOaaaaaaaaaahhhhhhhhh...", french=" RRRRRROOOOOONNNNNNNNNN...", german=" GOOOOOaaaaaaaaaah...", italian=" ROOONFaaaaaaaaaahhhhhhhhh...", spanish=" Grooooooooooooooonf..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" GooooOOOOOOAAAAAAAHHHHH...", french=" ZZZZZZZzzzzzzzzz...", german=" GooooOOOOOOAAAAAAAH...", italian=" RooooOOOOONFAAAAAAAHHHHH...", spanish=" Fiiiiiiiiuuuuuuuu..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="GUUUUGAAAAAaaaaaaaaaaaAAAA![K]\nGUUUGAAAH!?[K] GooooOOOOOOAAAAAAAHHHHH...", french="RRRooooooOOOOON![K]\nZZZzzzz?! [K]RRRROOOOOOOoooonnnNNNN...", german="GUUUUGAAAAAaaaaaaaaaaaAAAA![K]\nGUUUGAAAH?!?[K] GooooOOOOOOAAAAAAAH...", italian="ZZZZZZZZZzzzzzzzzzZZZZZZ![K]\nRONFRONFAAAH!?[K] RooonfAAAAAAAAAHHHHH...", spanish="¡Groooooooooooooonf![K]\n¿¡Grooooonf!?[K] Fiiiiiiiiiiiiiiiuuuuuuuuu..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="GUGOOOOOAAAAAAaaaaahhhhh![K]\nGUGOAAAAAA!![K]\nGUGAGOGOGOGOOOOOOOOoooooOOAAAAAAHHH!!", french="RRRROOOOoooonnnRRRRRonnn![K]\nZZZZZZZZZZzzzz!![K]\nROOOOOOOOOOOOOONNZzzzzzzzzRRRRONN!!", german="GUGOOOOOAAAAAAaaaaah![K]\nGUGOAAAAAA![K]\nGUGAGOGOGOGOOOOOOOOoooooOOAAAAAAH!", italian="ROOOROOONFAAAAAAaaaaahhhhh![K]\nZZZZZZZZZZZZ!![K]\nRORORORORORORONFFFFFFFAAAAAAHHH!!", spanish="¡Grooooooooooooooonf![K]\n¡¡Grooooonf!![K]\n¡¡Fiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiuuuuuuuuuuuuuuuuuu!!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="KUGOOOOooooaaaaaaahhhh![K]\nGUGOOOOOAAAAAAAaaaaaaahhhhhhh!", french="RRRONZZZZRONRONZZZZZZZZ![K]\nZZZZZZZZZZZZZZZZzzzzzzzzzzzzzzzzzzzzzzz!", german="KUGOOOOooooaaaaaaah![K]\nGUGOOOOOAAAAAAAaaaaaaah!", italian="ZZZZZZZZZaaaaaaahhhh![K]\nROROOONFAAAAAAAaaaaaaahhhhhhh!", spanish="¡Grooooooooooooonf![K]\n¡Fiiiiiiiiiiiiiiiiiuuuuuuuuuuuuuuuu!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] He's snoring too loud...\nI can't sleep...", french="Snif...[K]\nIl ronfle comme c'est pas permis...\nImpossible de fermer l'œil...", german="Schnüff...[K] Er schnarcht zu laut...\nIch kann nicht schlafen...", italian="Sniff...[K] Russa come un treno...\nNon riesco a dormire...", spanish="Jo...[K] Qué manera de roncar...\nAsí no hay quien pegue ojo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'd like to wake [CS:N]Loudred[CR] up...[K]\nBut...", french="J'aimerais réveiller [CS:N]Ramboum[CR]...[K]\nMais...", german="Ich würde [CS:N]Krakeelo[CR] gerne\naufwecken...[K] Aber...", italian="Vorrei svegliare [CS:N]Loudred[CR]...[K]\nMa...", spanish="De buena gana despertaría a\n[CS:N]Loudred[CR].[K] Pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If I did that, he'd be pretty\nangry, and that's a scary thought...[K]\nSniff...", french="Si j'faisais ça, il s'rait trop\nfurax, et là, ça f'rait peur...[K]\nSnif...", german="Täte ich das, wäre er sicherlich\nziemlich wütend...[K] Was für ein\nfurchteinflößender Gedanke. Schnief...", italian="... se lo facessi, andrebbe su\ntutte le furie e al solo pensarci mi\nviene paura...[K] Sniff...", spanish="Huy...[K] Si lo hiciera se enfadaría\nde lo lindo, y eso me da miedo."})
  -- se_FadeOut(9217, 10) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]Speaking of scary!", french="...[K]\nA propos d'trucs qui font peur!", german=" ...[K]Apropos furchteinflößend!", italian=" ...[K] A proposito di paura!", spanish=" Vaya...[K] ¡Ahora que me acuerdo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Those two I met earlier today...[K]\nThose Pokémon sure were scary, yup yup...", french="Ces deux Pokémon que j'ai\ncroisés aujourd'hui...[K] Ils faisaient\npeur, pardi...", german="Diese beiden von heute früh...[K]\nDiese Pokémon haben mir wirklich einen\nSchrecken eingejagt, jawollja...", italian="Quei due che ho incontrato oggi...[K]\nerano dei Pokémon davvero minacciosi,\ngià, già...", spanish="Esos dos que vi antes...[K]\nEsos Pokémon sí que daban miedo, sí, señor."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K]Just before those two\nshowed...[K]there was that Pokémon that seemed\nto be running away and then disappeared...", french="...[K] Juste avant qu'ils arrivent...[K]\nj'ai vu ce Pokémon qui avait l'air d's'enfuir\net qui a disparu...", german="...[K]Und kurz bevor die beiden\nauftauchten,[K] war da dieses Pokémon, das zu\nfliehen schien und dann verschwand...", italian="...[K] Appena prima che saltassero\nfuori...[K] è arrivato quel Pokémon. Sembrava\nche stesse scappando, poi è svanito...", spanish="Justo...[K] Justo antes de que\naparecieran...[K] Pasó aquel Pokémon que parecía\nestar huyendo y desapareció..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That Pokémon...[K] He was\nprobably being chased by those two\nscary Pokémon...", french="Ce Pokémon...[K] Il était\nsûrement poursuivi par les deux\naffreux...", german="Dieses Pokémon...[K] Vielleicht\nwurde es von den beiden furchteinflößenden\nPokémon verfolgt...", italian="Mmmh...[K] Forse quei due\nPokémon minacciosi gli stavano\ndando la caccia...", spanish="A aquel Pokémon...[K] probablemente\nlo persiguieran esos dos Pokémon\ntan horripilantes."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If that was the case, I hope he\ngot away all right...", french="Si c'est vrai, j'espère qu'il s'en\nest bien tiré...", german="Wenn das der Fall war, hoffe\nich, dass es gut davongekommen ist...", italian="Se fosse così, spero che sia\nriuscito a scappare...", spanish="Si era así, espero que pudiera\nescapar sin problemas..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That's right![K] When that Pokémon\nran off...", french="J'y pense![K] Quand il\ns'est enfui...", german="Oh, stimmt ja![K] Als dieses\nPokémon vorbeirannte...", italian="Un momento![K] Quando\nquel Pokémon è fuggito...", spanish="¡Es verdad![K] Cuando aquel\nPokémon salió huyendo..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
