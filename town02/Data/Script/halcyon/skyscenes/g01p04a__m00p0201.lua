-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m00p0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 232, 224, Direction.Down, "NPC_GUREGGURU")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end) -- message_SetActor(ACTOR_NPC_GUREGGURU)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh! Hey, you two\nover there...", french="Mwé hé hé... Hé, vous deux,\nvenez par ici...", german=" Mehehe! Hey, ihr zwei...", italian=" Eh eh eh! Ehi, voi due...", spanish=" ¡Je, je, je! ¡Eh! Venid, venid..."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_guregguru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, it's [CS:N]Croagunk[CR]!", french=" Oh! C'est [CS:N]Cradopaud[CR]!", german=" Hey, [CS:N]Glibunkel[CR]!", italian=" Oh, è [CS:N]Croagunk[CR]!", spanish=" ¡Anda, es [CS:N]Croagunk[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, it's [CS:N]Croagunk[CR]!", french=" Oh! C'est [CS:N]Cradopaud[CR]!", german=" Hey, das ist [CS:N]Glibunkel[CR]!", italian=" Oh, è [CS:N]Croagunk[CR]!", spanish=" Eh, ¡es [CS:N]Croagunk[CR]!"})
  else
  SkySceneKit.say({english=" Oh, it's [CS:N]Croagunk[CR]!", french=" Oh! C'est [CS:N]Cradopaud[CR]!", german=" Oh! [CS:N]Glibunkel[CR]!", italian=" Oh, è [CS:N]Croagunk[CR]!", spanish=" ¡Oh! ¡Es [CS:N]Croagunk[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-48), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-48), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  GAME:FadeOut(false, 30)
  pcall(function() GAME:MoveCamera(228, 244, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(hero, 212, 260, Direction.Down)
  GROUND:TeleportTo(partner, 244, 260, Direction.Down)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh.[K] What are you up\nto with [CS:N]Bidoof[CR] and the others? It all looks\nso sneaky.", french="Mwé hé hé...[K] Qu'est-ce que vous\nmijotez avec [CS:N]Keunotor[CR] et les autres?\nÇa m'a l'air bien louche, tout ça...", german="Mehehe.[K] Was treibt ihr denn da\nmit [CS:N]Bidiza[CR] und den anderen? Scheint ja sehr\ninteressant zu sein.", italian="Eh eh eh.[K] Cosa combinate\ncon [CS:N]Bidoof[CR] e gli altri? Sembra tutto così\nsegreto.", spanish="¿Qué os traéis entre manos con\n[CS:N]Bidoof[CR] y los demás? Parece muy sospechoso.[K]\nJe, je, je."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I suppose it's got nothing to do\nwith me, but... Meh-heh-heh.", french="J'imagine que ça ne me regarde\npas, mais... Mwé hé hé...", german="Wahrscheinlich hat es nichts mit\nmir zu tun, aber... Mehehe!", italian="Immagino non mi riguardi...\nEh eh eh.", spanish="Aunque supongo que no es asunto\nmío. Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Anyway, that's not why I called\nyou here.[K] Meh-heh-heh! The waiting's over!", french="Bon, ce n'est pas pour ça que\nje vous ai demandé de venir ici.[K] Mwé hé hé!\nVotre longue attente touche à sa fin!", german="Egal, ich habe euch wegen etwas\nanderem gerufen.[K] Mehehe! Das Warten hat ein\nEnde!", italian="Ma non è di questo che vi voglio\nparlare.[K] Eh eh eh! L'attesa è finita!", spanish="De todas formas, no os llamaba\npor eso.[K] ¡Ha llegado el gran momento!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="It's about my shop.[K] Meh-heh-heh!\nThe [CS:K]Croagunk[CR] Swap Shop is back in business!", french="Je veux vous parler de ma\nboutique.[K] Mwé hé hé... Le [CS:K]Stand Troc\nCradopaud[CR] est de retour!", german="Es geht um meinen Laden.[K]\nMehehe! Die [CS:K]Glibunkel-Tauschbörse[CR] hat\nwieder geöffnet!", italian="Si tratta del mio negozio.[K]\nEh eh eh! Il Centro Cambi [CS:K]Croagunk[CR] riapre!", spanish="Se trata de mi negocio.[K] Je, je, je.\n¡[CS:K]Trueques Croagunk[CR] reabre sus puertas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:K]Croagunk[CR]...[K]Swap Shop?", french=" Le...[K] [CS:K]Stand Troc Cradopaud[CR]?", german=" Die [CS:K]Glibunkel-Tauschbörse[CR]?", italian=" Centro Cambi[K] [CS:K]Croagunk[CR]...?", spanish=" ¿Cómo?[K] ¿[CS:K]Trueques Croagunk[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:K]Croagunk[CR]...[K]Swap Shop?", french=" Le...[K] [CS:K]Stand Troc Cradopaud[CR]?", german=" Die [CS:K]Glibunkel-Tauschbörse[CR]?", italian=" Centro Cambi[K] [CS:K]Croagunk[CR]...?", spanish=" ¿Cómo?[K] ¿[CS:K]Trueques Croagunk[CR]?"})
  else
  SkySceneKit.say({english=" [CS:K]Croagunk[CR]...[K]Swap Shop?", french=" Le...[K] [CS:K]Stand Troc Cradopaud[CR]?", german=" Die [CS:K]Glibunkel-Tauschbörse[CR]?", italian=" Centro Cambi[K] [CS:K]Croagunk[CR]...?", spanish=" ¿Cómo?[K] ¿[CS:K]Trueques Croagunk[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Meh-heh-heh! You heard right.", french="Mwé hé hé... Vous avez bien\nentendu...", german=" Mehehe! Richtig gehört.", italian=" Eh eh eh! Proprio così.", spanish=" ¡Je, je, je! Habéis oído bien."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I finally finished repairing my\nSwap Cauldron, which means that I'm finally\nback in business again! Meh-heh-heh!", french="J'ai enfin fini de réparer mon\nChaudron-Troc, ce qui signifie que je peux\nenfin réouvrir ma boutique! Mwé hé hé...", german="Ich habe endlich meinen\nTauschkessel repariert und kann wieder ins\nGeschäft einsteigen! Mehehe!", italian="Ho finalmente finito di riparare\nil Pentolone dei Cambi, il che significa che\nposso finalmente riaprire! Eh eh eh!", spanish="Por fin he terminado de reparar\nmi Caldero de Trueque, ¡lo que significa que\npor fin he vuelto al negocio! ¡Je, je, je!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="You put certain kinds of items in\nthis here Swap Cauldron...", french="En gros, on dépose divers objets\nici, dans le Chaudron-Troc...", german="Werft bestimmte Arten von\nItems in den Tauschkessel...", italian="Si mettono certi strumenti nel\nPentolone dei Cambi...", spanish="Solo hay que poner ciertos tipos\nde objetos en este Caldero de Trueque..."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="And those items get swapped for\nan item offered up by another Pokémon\nsomewhere around Treasure Town.", french="... et ces objets sont troqués\ncontre un objet proposé par un autre Pokémon\ndes alentours de Bourg-Trésor.", german="Und ihr bekommt dann dafür ein\nItem, das ein anderes Pokémon aus der Gegend\num Schatzstadt zum Tausch angeboten hat.", italian="... e quegli strumenti vengono\ncambiati con uno strumento offerto da un\naltro Pokémon di Borgo Tesoro.", spanish="Y se reciben a cambio otros\nobjetos dejados por los Pokémon de\nAldea Tesoro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="There are some Pokémon around\nthat have pretty rare items for swapping.", french="Certains Pokémon proposent\nau troc des objets extrêmement rares.", german="Einige Pokémon hier bieten\nziemlich seltene Items zum Tausch an.", italian="In giro ci sono dei Pokémon che\nhanno degli strumenti abbastanza rari da\ncambiare.", spanish="Hay algunos Pokémon que quieren\nintercambiar objetos difíciles de encontrar."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="So you could end up with a\nstupendously great swap. Get it?\nMeh-heh-heh!", french="Il se peut donc que vous fassiez\nde très bonnes affaires en troquant. Compris?\nMwé hé hé...", german="Mit etwas Glück erwischt ihr\nalso ein richtig tolles Item. Kapiert?\nMehehe!", italian="Quindi potrebbe capitarvi di fare\nun cambio estremamente vantaggioso. Tutto\nchiaro? Eh eh eh.", spanish="Y podéis salir muy beneficiados\ncon el cambio. ¿Comprendéis? ¡Je, je, je!"})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="So if you two feel like swapping\nitems, you bring them to me, all right?\nMeh-heh-heh!", french="En gros, si vous avez envie\nde troquer des objets, apportez-les-moi,\nd'accord? Mwé hé hé...", german="Wenn euch also mal nach einem\nTauschgeschäft ist, kommt zu mir. Alles klar?\nMehehe!", italian="Quindi, se vi va di cambiare\ndegli strumenti, portateli a me, va bene?\nEh eh eh!", spanish="Si os apetece intercambiar\nobjetos, venid a verme, ¿de acuerdo?\n¡Je, je, je!"})
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[31] = 1 -- $PERFORMANCE_PROGRESS_LIST[31] = 1 (ROM)
  SkySceneKit.cleanup_npcs()
end
