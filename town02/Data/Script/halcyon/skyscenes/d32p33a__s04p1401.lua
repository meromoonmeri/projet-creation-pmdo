-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P33A/s04p1401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 65) -- $SCENARIO_MAIN = scn[29,65] (ROM)
  -- back_SetGround(LEVEL_D32P33A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(7950) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D32P44A5_88) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- SetOutputAttribute(4) [neutre/état moteur]
  GAME:WaitFrames(60)
  -- MovePositionMark OBJECT_D32P44A5_88 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D32P44A5_88) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(30)
  -- se_FadeOut(7950, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]A mysterious light\n[CN]enveloped [player]!", french="[CN]Une lumière mystérieuse\n[CN]enveloppe [player]!", german="[CN]Ein mysteriöses Licht\n[CN]umhüllt [player]!", italian="[CN]Una luce misteriosa\n[CN]avvolge [player]!", spanish="[CN]¡Una luz misteriosa\n[CN]ha envuelto a [player]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(7951) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D32P44A5_88) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The guardian's permission was granted!", french="[CN]Le gardien vous accorde le droit de continuer!", german="[CN]Der Torwächter gewährt seine Erlaubnis!", italian="[CN]Hai ottenuto il permesso del guardiano!", spanish="[CN]¡Has conseguido el permiso del guardián!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(180, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  -- GAP: se_Play(7187) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  GAME:WaitFrames(10)
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(1) [neutre/état moteur]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(612, 268, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  -- GAP: se_Play(7175) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 644 — VFX sans émote PMDO équivalente
  -- GAP: SetEffect 644 — VFX sans émote PMDO équivalente
  -- GAP: SetEffect 644 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(30)
  -- supervision_Acting(2) [neutre/état moteur]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 648, 216, Direction.Right, "NPC_SAANAITO")
  -- SetAnimation(22) [anim idle native]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 584, 216, Direction.Down, "NPC_CHAAREMU")
  -- SetAnimation(22) [anim idle native]
  local npc_npc_mimiroppu = SkySceneKit.spawn_npc("lopunny", 616, 208, Direction.Down, "NPC_MIMIROPPU")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-16), 16, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_mimiroppu.Position; GROUND:MoveToPosition(npc_npc_mimiroppu, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_mimiroppu.Position; GROUND:MoveToPosition(npc_npc_mimiroppu, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_mimiroppu.Position; GROUND:MoveToPosition(npc_npc_mimiroppu, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_mimiroppu.Position; GROUND:MoveToPosition(npc_npc_mimiroppu, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" Urr... Urgh...", french=" Ah... Argh...", german=" Argh... Uff...", italian=" Urr... Urgh...", spanish=" Grrr..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(7)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Left)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" Wh-what happened to us...?", french=" Qu'est-ce qui nous est arrivé...?", german=" W-was ist mit uns geschehen?", italian=" C-Cosa ci è successo...?", spanish=" ¿Qué... qué nos ha pasado?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Oh![K] We were fighting [CS:N]Registeel[CR]\nhere...[K] Then [CS:N]Medicham[CR] got into trouble...", french="Oh![K] Nous étions en train\nd'affronter [CS:N]Registeel[CR]...[K] et puis [CS:N]Charmina[CR]\na eu des ennuis...", german="Oh![K] Wir haben hier mit [CS:N]Registeel[CR]\ngekämpft...[K] Dann ist [CS:N]Meditalis[CR] in\nSchwierigkeiten geraten...", italian="Oh![K] Stavamo affrontando\n[CS:N]Registeel[CR] qui...[K] Poi [CS:N]Medicham[CR] è finita nei\nguai...", spanish="¡Oh![K] Estábamos luchando con\n[CS:N]Registeel[CR] aquí...[K] y [CS:N]Medicham[CR] estaba en\napuros..."})
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="...[K]After that, I just don't know.\nI don't know what came next.", french="...[K] Après ça, je ne me souviens\nplus de rien. Je ne sais pas ce qui s'est passé\nensuite.", german="...[K]Aber ich weiß einfach nicht,\nwas danach passiert ist.", italian="...[K] Dopo, non lo so.\nNon so cosa è successo dopo.", spanish="No recuerdo...[K] No recuerdo\nqué pasó después."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="I can see that you saved us\nthough, Team [team:].", french="Je constate que vous nous avez\nsauvées, chère Equipe [team:].", german="Ich muss allerdings anerkennen,\ndass ihr uns gerettet habt, Team [team:].", italian="Ma vedo che ci avete salvate,\nTeam [team:].", spanish="Pero nos habéis salvado, [CS:X]Equipo[CR]\n[team:]."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" Thank you! We were in a bind!", french="Merci beaucoup! Nous étions\ndans le pétrin.", german="Danke! Wir sind echt in\nVerlegenheit geraten.", italian="Grazie! Eravamo\ndavvero alle strette.", spanish="Gracias, encantos.\nEstábamos en un buen aprieto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We owe you one, Team\n[team:].", french="Nous vous devons une fière\nchandelle, chère Equipe [team:].", german="Wir schulden euch etwas, Team\n[team:].", italian="Siamo in debito con voi,\nTeam [team:].", spanish="Os debemos una, [CS:X]Equipo[CR]\n[team:]."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="If you didn't show up in time to\nsave us, that would've been it for us.", french="Sans votre intervention, c'en\nétait fini de nous.", german="Wärt ihr nicht rechtzeitig\ngekommen, wäre es das für uns wohl gewesen.", italian="Se non ci aveste salvate in\ntempo, per noi sarebbe stata la fine.", spanish="Si no hubierais llegado justo\nen ese momento, no sé qué habría\npasado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" That is so true.", french=" C'est bien vrai.", german=" Da ist was Wahres dran.", italian=" Proprio così.", spanish=" Cierto."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="I'm afraid we can never repay\nyou for this...", french="J'ai bien peur que nous ne\npuissions vous rendre la pareille...", german="Ich fürchte, wir werden euch\nniemals angemessen dafür entlohnen können...", italian="Temo che non potremo mai\nripagarvi...", spanish="Creo que nunca podremos\nrecompensaros por..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" I know!", french=" Je sais!", german=" Da fällt mir etwas ein!", italian=" Un attimo!", spanish=" ¡Ya sé!"})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="How about letting us back you\nup at some point, Team [team:]?", french="Et si nous vous apportions\nnotre concours, Equipe [team:]? Qu'en\ndites-vous?", german="Wie wäre es, wenn wir euch\nirgendwann einmal helfen würden,\nTeam [team:]?", italian="Cosa ne dite se vi diamo una\nmano, Team [team:]?", spanish="¿Y si os vamos cubriendo\nlas espaldas, [CS:X]Equipo[CR] [team:]?"})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Yes, I think we've already failed\non our own exploration.", french="Oui, il semble de toute façon\nque nous ayons échoué dans notre propre\nexploration.", german="Ja, ich glaube, auf unserer\neigenen Erkundung sind wir bereits gescheitert.", italian="Sì, penso che la nostra\nesplorazione ormai sia fallita.", spanish="Total, ya hemos fracasado en\nnuestra expedición."})
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Tee-hee! Don't worry! We won't\ntry to steal your glory. Or your treasure!", french="Hi hi! Pas d'inquiétude! Nous\nn'avons pas l'intention de vous voler la vedette.\nOu le trésor, d'ailleurs!", german="Hihi! Keine Sorge! Wir wollen\neuren Ruhm nicht stehlen. Oder euren Schatz!", italian="Eeh-eeh! Non preoccupatevi! Non\nvi ruberemo il merito. E nemmeno il tesoro!", spanish="¡Ji, ji! ¡No os preocupéis!\n¡No os quitaremos la gloria! ¡Ni el tesoro!"})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Let's go![K] Our goal can't be far\noff now!", french="Allons-y![K] Notre objectif ne doit\nplus être très loin!", german="Gehen wir![K] Unser Ziel kann nicht\nmehr weit sein!", italian="Andiamo![K] Ormai il nostro\nobiettivo non dovrebbe essere molto lontano!", spanish="¡Sigamos![K] ¡No podemos estar\nlejos!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mimiroppu, 612, 124, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_chaaremu, 612, 124, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_saanaito, 612, 124, false, 2)
  GROUND:MoveToPosition(hero, 612, 124, false, 2)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 612, 124, false, 2) end end
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 612, 124, false, 2) end end
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 612, 124, false, 2) end end
  GAME:WaitFrames(15)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
