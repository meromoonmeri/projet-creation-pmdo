-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P11A/s20p0106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V03P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 248, 248, Direction.Down, "NPC_DAAKURAI")
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(4) [anim idle native]
  local npc_npc_shadow_daakurai = SkySceneKit.spawn_npc("darkrai", 248, 248, Direction.Down, "NPC_SHADOW_DAAKURAI")
  -- SetAnimation(4) [anim idle native]
  -- GAP: BGM BGM_STORM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(60)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(64) -- WhiteChange
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2)
  GAME:FadeIn(256) -- WhiteChange
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:FadeIn(64) -- WhiteChange
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(5)
  GAME:FadeIn(2) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  -- supervision_Acting(2) [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(80)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" ...[K]This is proceeding nicely.", french=" ...[K] Tout se déroule comme prévu.", german=" ...[K]Das scheint gut zu laufen.", italian=" ...[K] Sta andando bene.", spanish=" Hum...[K] Todo está saliendo como debería."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="This forest's distortion in the very fabric\nof space itself is growing.", french="Cette distorsion de la trame même\nde l'espace continue à s'étendre depuis\nla forêt.", german="Die Verzerrung dieses Waldes im\nRaumgefüge selbst wird größer.", italian="La distorsione della struttura dello spazio\ndi questa foresta sta crescendo.", spanish="La deformación del espacio en este bosque\nsigue aumentando."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Ah, the distortion of space and dimension\nitself![K] If it expands further...", french="Si la distorsion de l'espace et des\ndimensions...[K] continue de croître...", german="Ah, die Verzerrung von Raum und\nDimension an sich![K] Wenn sie sich weiter\nausdehnt...", italian="Ah, la distorsione dello spazio e della\ndimensione stessa![K] Se aumenta ancora...", spanish="Sí, las dimensiones y el propio espacio\nse están distorsionando...[K] cada vez más."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" My own power will be amplified!", french=" ... mon pouvoir s'en trouvera décuplé!", german=" Wird meine eigene Kraft verstärkt!", italian=" ... il mio potere crescerà!", spanish=" ¡Y eso aumentará mi poder!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I failed to destroy time...[K] But things will\nbe different now...", french="J'ai échoué dans la destruction du temps...\nMais cette fois, je jure que tout sera\ndifférent...", german="Die Zeit konnte ich nicht zerstören...[K]\nAber hier liegen die Dinge anders...", italian="Non sono riuscito a distruggere il\ntempo...[K] Ma adesso le cose andranno\ndiversamente...", spanish="No conseguí destruir el tiempo...[K]\nPero, ahora, todo será diferente..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Hm?![K] Someone's coming!", french=" Hum?![K] Quelqu'un approche!", german=" Hm?!?[K] Da kommt jemand!", italian=" Eh?![K] Sta arrivando qualcuno!", spanish=" ¡¿Eh?![K] ¡Viene alguien!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" It's [CS:N]Cresselia[CR]...[K] That persistent pest!", french="C'est [CS:N]Cresselia[CR]...[K] Cette peste\ncontinue à me coller aux basques!", german="Es ist [CS:N]Cresselia[CR]...[K] Diese\nhartnäckige Plage!", italian=" È [CS:N]Cresselia[CR].[K] Quella peste insistente!", spanish=" Es [CS:N]Cresselia[CR]...[K] ¡Qué pesada!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" I must not be caught...", french=" Je ne dois pas me faire prendre...", german=" Ich darf nicht entdeckt werden...", italian=" Non mi prenderanno...", spanish=" No debe atraparme..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Not ever!", french=" Jamais!", german=" Niemals!", italian=" Mai!", spanish=" ¡Nunca!"})
  -- message_Close
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(0)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(5)
  GAME:FadeIn(2)
  GAME:WaitFrames(60)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:FadeIn(0) -- screen_FlushIn
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 448, 240, Direction.Left, "NPC_KURESERIA")
  GROUND:MoveToPosition(npc_npc_kureseria, 248, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(64) -- WhiteChange
  GAME:WaitFrames(3)
  GAME:FadeIn(256) -- WhiteChange
  GAME:FadeIn(64) -- WhiteChange
  GAME:WaitFrames(5)
  GAME:FadeIn(2) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(60)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" ...[K]He got away again...", french=" ...[K] Il s'est encore enfui...", german=" ...[K]Es ist wieder entwischt...", italian="...[K] È riuscito a scappare\ndi nuovo...", spanish="Se ha vuelto...[K] Se ha vuelto a\nescapar..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="This is the closest that I've\never gotten...", french="C'est la première fois que\nj'arrive à m'en rapprocher autant...", german="So nah war ich noch nie an\nihm dran...", italian="Non mi ero mai avvicinata così\ntanto.", spanish=" He estado muy cerca esta vez..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" But he always slips away.", french="Mais il parvient toujours\nà me glisser entre les doigts.", german="Aber es entkommt mir immer\nwieder.", italian=" Ma riesce sempre a scappare.", spanish=" Pero siempre se me escapa."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="It may be difficult, perhaps\nimpossible, to catch him.", french="Cela va être difficile, voire\nimpossible de l'attraper.", german="Es könnte schwierig oder\nvielleicht unmöglich sein, es zu fangen.", italian="Sarà difficile, forse addirittura\nimpossibile, catturarlo.", spanish=" Es casi imposible atraparlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="No.[K] I can't give up. He has to\nbe caught.", french="Non.[K] Je ne peux pas abandonner\nmaintenant. Il faut absolument que je l'attrape.", german="Nein.[K] Ich kann nicht aufgeben.\nEs muss gefasst werden.", italian="No.[K] Non posso arrendermi.\nDeve essere fermato.", spanish="No.[K] No puedo rendirme.\nTengo que capturarlo."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="And the fabric of space being\ndistorted like this must stop! Before it\naccelerates further!", french="Et cette distorsion de l'espace\ndoit cesser à tout prix! Avant que cela ne\nprenne des proportions dramatiques!", german="Und diese extreme Verzerrung\ndes Raumgefüges muss aufhören! Bevor sie\nsich weiter beschleunigt!", italian="E bisogna mettere fine\nalla distorsione dello spazio! Prima che\nacceleri ancora!", spanish="¡Hay que detener la deformación\ndel espacio! ¡Antes de que sea demasiado\ntarde!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Before the world is thrown back\ninto turmoil!", french="Avant que le monde ne soit\nplongé dans le chaos!", german="Bevor die Welt im Chaos\nversinkt!", italian="Prima che il mondo venga\ndi nuovo gettato nel caos!", spanish=" ¡Antes de que se desate el caos!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" I've got to do whatever it takes.", french="Il faut que j'y arrive, quoi qu'il\nm'en coûte.", german=" Ich muss tun, was nötig ist.", italian=" Devo riuscirci a qualsiasi costo.", spanish=" Haré lo que haga falta."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" I must stop [CS:N]Darkrai[CR]!", french=" Je dois arrêter [CS:N]Darkrai[CR]!", german=" Ich muss [CS:N]Darkrai[CR] aufhalten!", italian=" Devo fermare [CS:N]Darkrai[CR]!", spanish=" ¡Tengo que detener a [CS:N]Darkrai[CR]!"})
  -- message_Close
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(64) -- WhiteChange
  GAME:WaitFrames(3)
  GAME:FadeIn(256) -- WhiteChange
  GAME:FadeIn(64) -- WhiteChange
  GAME:WaitFrames(5)
  GAME:FadeIn(2) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(60)
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 60)
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
