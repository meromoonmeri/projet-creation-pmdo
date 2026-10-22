-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P31A/s31a3705.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_D73P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 232, 200, Direction.Up, "NPC_GOORIKII")
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 256, 200, Direction.Up, "NPC_KINOGASSA")
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="I-I'm so glad that I climbed\nthis mountain...", french="J-je suis si content d'avoir\ngravi cette montagne...", german="I-ich bin so froh,\nden Berg bestiegen zu haben...", italian="S-Sono così felice di aver\nscalato questa montagna...", spanish="Ahora me alegro un montón\nde haber subido esta montaña."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 224, 176, Direction.Up, "NPC_KUCHIITO")
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" Me too...", french=" Moi aussi...", german=" Ich auch...", italian=" Anch'io...", spanish=" Yo también..."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="This is...[K]\nI'm speechless...", french=" C'est...[K] indicible...", german="Das ist einfach...[K]\nIch bin sprachlos...", italian="Tutto questo è...[K]\nSono senza parole...", spanish="Quiero decir...[K] Ni siquiera\ntengo palabras."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" I think this is the first time...", french="Je n'avais jamais rien\nvu de tel...", german="Ich glaube, das ist das\nerste Mal...", italian=" Credo che sia la prima volta...", spanish=" Creo que es la primera vez..."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="This must be the fabled\ntreasure that is superior to all\nother treasure...", french="Ce doit être ça, le trésor qui\nsurpasse les plus beaux trésors, celui\ndont parle la légende...", german="Das muss der sagenhafte Schatz\nsein, dem man nachsagt, er sei prächtiger als\nalle anderen...", italian="Deve essere questo il mitico\ntesoro che fa impallidire tutti gli altri...", spanish="Este debe de ser el tesoro\nlegendario que no tiene parangón..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kinogassa, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" [CS:N]Shaymin[CR]...", french=" [CS:N]Shaymin[CR]...", german=" [CS:N]Shaymin[CR]...", italian=" [CS:N]Shaymin[CR]...", spanish=" [CS:N]Shaymin[CR]..."})
  -- message_Close
  pcall(function() GAME:MoveCamera(252, 224, 60, false) end) -- performer/caméra
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 256, 288, Direction.Up, "NPC_SHEIMI")
  GROUND:MoveToPosition(npc_npc_sheimi, 252, 236, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_goorikii, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kuchiito, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.DownLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, npc_npc_sheimi, 4) end) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Thank you so much for guiding\nus here.", french="Merci beaucoup de nous avoir\nguidés jusqu'ici.", german="Vielen Dank, dass du uns\nden ganzen Weg hierhergeführt hast.", italian="Grazie mille per averci guidato\nfin qui.", spanish="Muchísimas gracias por guiarnos\nhasta aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" My pleasure!", french=" Pas de problème!", german=" Es war mir ein Vergnügen!", italian=" Figurati!", spanish=" ¡De nada!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I had fun climbing the mountain\nwith all of you!", french="Je me suis bien amusée\nà escalader cette montagne avec vous!", german="Und es hat mir Spaß gemacht,\nmit euch allen den Berg zu besteigen!", italian="Mi sono divertita moltissimo\na scalare la montagna con tutti voi!", spanish="Yo me lo he pasado pipa\nsubiendo a la montaña con vosotros."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" So, thank you very much!", french=" Alors, merci pour tout!", german=" Daher danke ich euch!", italian="Quindi sono io che devo\nringraziarvi!", spanish=" Así que muchas gracias."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Well...[K]we should do this\nagain sometime!", french="Et...[K] on devrait\nremettre ça, une fois!", german="Nun...[K] Wir sollten das\nirgendwann noch einmal wiederholen!", italian="Beh...[K] Dovremmo rifarlo\nqualche volta!", spanish="Bueno...[K] ¡Esto hay que repetirlo\nalgún día!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" Yes!", french=" Oui!", german=" Auf jeden Fall!", italian=" Sì!", spanish=" ¡Sí, sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="It seems like you really enjoyed\nthe view from the summit...", french="Vous avez eu le temps d'admirer\nla vue qu'on a du sommet...", german="Euch hat der Ausblick vom Gipfel\nwohl wirklich gefallen...", italian="Sembra che vi sia davvero\npiaciuto il panorama che si gode dalla cima...", spanish="Parece que habéis disfrutado\nmucho de las vistas desde la cima..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Shall we head back to the base\nof the mountain?", french="On redescend au pied\nde la montagne?", german="Sollen wir zum Fuße\ndes Berges zurückkehren?", italian="Che ne dite, torniamo alla base\ndella montagna?", spanish=" ¿Volvemos al pie de la montaña?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" Yeah!", french=" Ouais!", german=" Ja!", italian=" Va bene!", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:WaitFrames(45)
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=".........[K]\n................................................", french="..........[K]\n................................................", german=".........[K]\n................................................", italian="..........[K]\n................................................", spanish=" ...[K] ..."})
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" ...Heading back means...", french=" ... Redescendre, ça veut dire...", german=" ...Zurückkehren bedeutet...", italian=" ... Tornare significa...", spanish=" Eso significa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Aaaah!\nWe didn't think about how to get back down!", french="Aaaah!\nIl faut redescendre?!", german="Ooooh! Wir haben uns gar keine\nGedanken gemacht, wie wir wieder\nherunterkommen!", italian="Aaah!\nNon avevamo pensato a come tornare a valle!", spanish="¡Ahí va! No hemos pensado\nen cómo bajar."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" You've got to go back down!?", french=" On n'avait jamais réfléchi à ça!", german="Man muss also\nauch wieder hinunter?!?", italian=" Come possiamo fare!?", spanish=" ¿Queréis bajar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "shock", 1) end)
  GAME:WaitFrames(7)
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Calm down. It's fine.", french=" Calmez-vous, tout va bien.", german="Beruhigt euch. Ist ja alles\nin Ordnung.", italian=" Calma, non vi preoccupate.", spanish=" Calma, no pasa nada."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I'll take you all back to the base\nof the mountain, no problem.", french="Je vais tous vous faire\nredescendre de la montagne, aucun problème.", german="Ich werde euch alle zum Fuße\ndes Berges zurückbringen. Gar kein Problem.", italian="Vi riporto io alla base\ndella montagna, non c'è problema.", spanish="Voy a llevaros de vuelta al pie\nde la montaña, no hay problema."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" Huh? How will you do that?", french=" Oh? Et comment vas-tu faire?", german="Hmmm?\nWie willst du das machen?", italian=" Eh? E come faresti?", spanish=" ¿Eh? ¿Cómo piensas hacer eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sheimi, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="There's a special flower here\ncalled the [CS:I]Gracidea[CR]. It's a special flower for\nus [CS:K]Shaymin[CR].", french="On trouve une fleur spéciale ici,\nqu'on appelle [CS:I]Gracidée[CR]. C'est une fleur aux\nvertus spéciales pour nous, les [CS:K]Shaymin[CR].", german="Hier oben wächst eine spezielle\nBlume namens [CS:I]Gracidea[CR]. Für uns [CS:K]Shaymin[CR]\nhat sie eine besondere Bedeutung.", italian="In questo posto c'è un fiore\nspeciale chiamato [CS:I]Gracidea[CR].\nPer noi [CS:K]Shaymin[CR] è davvero prezioso.", spanish="Aquí brota una flor conocida\ncomo [CS:I]Gracídea[CR]. Es muy especial para\nlos [CS:K]Shaymin[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" How is it special, you ask?", french="Vous vous demandez ce qu'elle\na de spécial?", german="Ihr fragt euch vielleicht,\nauf welche Art besonders?", italian=" Perché è speciale, vi chiedete?", spanish=" ¿Que qué tiene de especial?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(24), 48, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- supervision_Acting(2) [neutre/état moteur]
  -- GAP: se_Play(11018) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D73P41A6_418) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  local npc_npc_sheimi_fc = SkySceneKit.spawn_npc("shaymin", 256, 240, Direction.Right, "NPC_SHEIMI_FC")
  GROUND:EntTurn(npc_npc_sheimi_fc, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi_fc) end)
  SkySceneKit.say({english="I just touch the flower like this,\nand I can change Forme temporarily.", french="Il suffit que je touche la fleur\ncomme ceci... pour changer temporairement\nde Forme.", german="Ich fasse die Blume einfach auf\neine bestimmte Art an. Und schon kann ich eine\nbegrenzte Zeit lang meine Form ändern.", italian="Beh, mi basta toccare il fiore\nper cambiare temporaneamente Forma.", spanish="Pues toco la flor así y puedo\ncambiar temporalmente de forma."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-24), 24, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" Wow...", french=" Waouh...", german=" Wow...", italian=" Wow...", spanish=" Caramba..."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Are you really that adorable...[K]\n[CS:N]Shaymin[CR]...?", french="Tu es si adorable...[K]\n[CS:N]Shaymin[CR]...", german="Bist du echt so süß?[K]\n[CS:N]Shaymin[CR]?", italian="Ma davvero sei così\neccezionale...[K] [CS:N]Shaymin[CR]...?", spanish="¿Cómo puedes ser tan adorable,[K]\n[CS:N]Shaymin[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi_fc, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi_fc) end)
  SkySceneKit.say({english="Hee-hee-hee.\nWhen I'm in this Forme, I can fly.", french="Hi hi hi.\nQuand je suis sous cette Forme, je peux voler.", german="Hi-hi-hi.\nIn dieser Form kann ich fliegen.", italian="Ih ih ih.\nQuando assumo questa Forma, posso volare.", spanish=" Ji, ji, ji. En esta forma puedo volar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi_fc, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" You can fly? That means...", french=" Tu peux voler? Ça veut dire...", german="...Du kannst fliegen?\nDas bedeutet...", italian=" Puoi volare? Questo significa...", spanish=" ¿Que puedes volar? Entonces..."})
  -- message_Close
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 15)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
