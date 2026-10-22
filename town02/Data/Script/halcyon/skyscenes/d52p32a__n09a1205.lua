-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D52P32A/n09a1205.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- back_SetGround(LEVEL_D52P32A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 256, 144, Direction.Down, "NPC_SEREBII")
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 256, 288, Direction.Up, "NPC_YONOWAARU_N9")
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(7)
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Heh heh heh.[K] It's taken you\nlong enough to catch on, [CS:Y]Grovyle[CR].", french="Hé hé hé.[K] Tu as mis du temps\nà comprendre, [CS:Y]Massko[CR].", german="Hehehe.[K] Du hast aber ganz schön\nlange gebraucht, das zu durchblicken, [CS:Y]Reptain[CR].", italian="Eh eh eh![K] C'è voluto un bel po',\nma alla fine ci sei arrivato, [CS:Y]Grovyle[CR].", spanish="Ja, ja, ja...[K] Te ha costado lo suyo\npillarlo, [CS:Y]Grovyle[CR]."})
  -- message_KeyWait
  -- SetAnimation(39) [anim idle native]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" HA HA HA HAH HAH HAH!", french=" HA HA HA HA HA HA!", german=" HAHAHA HAH HAH HAH!", italian=" AH AH AH AH AH AH AH AH AH!", spanish=" ¡¡Jua, jua, jua, jua!!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(10767) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" EEEEeeaaahhhhhh!", french=" Aaaaaaah!", german=" EEEEeeaaah!", italian=" Uuuuuuaaahhhhhh!", spanish=" ¡¡¡Aaay!!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 204, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" [CS:Y]Gr[CR]... [CS:Y]Grovyle[CR]!", french=" [CS:Y]Ma[CR]... [CS:Y]Massko[CR]!", german=" [CS:Y]R-Reptain[CR]!", italian=" [CS:Y]Gr-Grovyle[CR]!", spanish=" [CS:Y]Gro[CR]... ¡[CS:Y]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- se_FadeOut(10767, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_ANOTHER_STATIC_NOISE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:WaitFrames(45)
  pcall(function() GAME:MoveCamera(252, 284, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(7)
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Hm hm hm ha.[K] You've been in my\nway the entire time...", french="Mwah ha ha.[K] Tu n'as eu de cesse\nde faire échouer mes plans...", german="Hmmhmmhmha.[K] Du warst mir die\nganze Zeit ein Dorn im Auge...", italian="Hm hm hm ah.[K] Hai finito\ndi mettermi i bastoni tra le ruote...", spanish="Ja, ja, ja...[K] Has sido un estorbo\npara mí todo este tiempo..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" And now your time is up.", french="... mais c'est toi qui as fini\npar échouer.", german=" Aber deine Zeit ist abgelaufen.", italian=" Il tuo tempo è scaduto.", spanish=" Ya llegó tu hora."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And when I inhabit your empty\nshell and return to the past...", french="Et quand je me serai glissé dans\nton corps pour retourner dans le passé...", german="Und wenn ich erst mal die\nKontrolle über deine leere Hülle erlangt und\ndie Vergangenheit erreicht habe...", italian="E quando mi impossesserò\ndel tuo corpo e tornerò nel passato...", spanish="Cuando controle tu cuerpo\ny regrese al pasado..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It will be child's play to take\ndown [c_name:NPC_HERO_FIRST] and [c_name:NPC_PARTNER_FIRST]!", french="Ce sera un jeu d'enfant de me\ndébarrasser de [c_name:NPC_HERO_FIRST] et [c_name:NPC_PARTNER_FIRST]!", german="Dann wird es ein Kinderspiel\nsein, [c_name:NPC_HERO_FIRST] und [c_name:NPC_PARTNER_FIRST]\nendlich auszutricksen!", italian="... sconfiggere [c_name:NPC_HERO_FIRST]\ne [c_name:NPC_PARTNER_FIRST] sarà un gioco da ragazzi!", spanish="¡Será un juego de niños acabar\ncon [c_name:NPC_HERO_FIRST] y [c_name:NPC_PARTNER_FIRST]!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Give up now and let your spirit\nbe melted away!", french="Abandonne et dis adieu à\ntes souvenirs!", german="Nun gib schon auf und füge\ndich deinem Schicksal!", italian="Arrenditi e lascia che la tua\ncoscienza svanisca!", spanish="¡Ríndete ya y te dolerá\nmenos debilitarte!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(10767) — id SE NDS sans portage PMDO identifié
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Gyaaaaaaaaaah!", french=" Aaaaaaaahhh!", german=" Gyaaaaaaaaaah!", italian=" Guaaaaaaaaaah!", spanish=" ¡¡Aaaaaaaah!!"})
  -- message_Close
  GAME:WaitFrames(30)
  -- se_FadeOut(10767, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh! Was I...[K] Was I too\ntrusting...", french="Oh! Aurais-je été...[K] trop\nconfiant?", german="Ächz! War ich...[K] War ich zu\nvertrauensselig?", italian="Oh! Io...[K] mi sono fidato come\nuno sciocco...", spanish="¡Oh! ¿He sido...?[K] ¿He sido\ndemasiado confiado?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I thought I could...[K] But I...[K]\nBelieved you...", french="Je pensais y arriver...[K] Mais...[K]\nje t'ai cru...", german="Ich dachte, ich könne dir...[K]\nAber...[K] Ich habe dir geglaubt...", italian="Pensavo che avrei potuto...[K]\nPerò io...[K] ti ho creduto...", spanish="Pensé que podía...[K] Yo...[K]\nYo te creí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" That's right, [CS:Y]Grovyle[CR].", french=" Certes, [CS:Y]Massko[CR].", german=" Das stimmt, [CS:Y]Reptain[CR].", italian=" Esatto, [CS:Y]Grovyle[CR].", spanish=" Así es, [CS:Y]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Your weak point is that you're\ntoo kind.", french="Ta générosité est ta plus\ngrande faiblesse.", german="Der Punkt, an dem du wirklich\nangreifbar bist, ist deine Vertrauensseligkeit.", italian="Il tuo punto debole è che sei\ntroppo buono.", spanish="Tu punto débil es que eres\ndemasiado bueno."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I've said it before. Allow me to\nrepeat it for emphasis.[K] I really despise you.", french="Je l'ai déjà dit, mais laisse-moi\nle répéter, que ce soit bien clair.[K]\nJe n'ai que du mépris pour toi.", german="Ich habe es bereits gesagt, aber\nich wiederhole es gerne, um es klarzustellen:[K]\nIch verabscheue dich.", italian="Te l'ho già detto prima, ma\nlascia che te lo ripeta un'altra volta.[K]\nIo non ti sopporto.", spanish="No te mentía cuando te lo dije.[K]\nTe odio con todas mis fuerzas."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Even when I shielded you...[K] It\nwas simply according to plan.", french="Même quand je t'ai protégé...[K]\ncela faisait partie du plan.", german="Selbst als ich dich beschützte...[K]\nDas war alles im Sinne meines Plans.", italian="Anche quando ti ho protetto...[K]\nFaceva solo parte del mio piano.", spanish="Incluso cuando te protegí...[K]\nera necesario para cumplir el plan."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 204, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" You![K] You coward!", french=" Traître![K] Lâche!", german=" Du![K] Du Feigling!", italian=" Tu![K] Codardo!", spanish=" ¡Tú![K] ¡Serás cobarde!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 284, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(39) [anim idle native]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="HA HA HA HA![K] You can babble\nwhatever you like!", french="HA HA HA HA![K] Verbiage\nsans intérêt aucun!", german="HAHAHAHA![K] Sag du nur,\nwas immer du willst!", italian="AH AH AH![K] Puoi agitarti quanto\nvuoi!", spanish="¡Ja, ja, ja, ja![K] Ahora puedes\ndecir lo que te dé la gana..."})
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" In the end, you have lost!", french=" Tu as perdu, voilà tout!", german="Aber ihr müsst am Ende\neinsehen, dass ihr verloren habt!", italian=" Ma alla fine, la vittoria è mia!", spanish="Es el final, ¡y has perdido\nla partida!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="You've lost because...[K]you\ntrusted me!", french="Tu as perdu parce que...[K]\ntu m'as fait confiance!", german="Ihr habt verloren, weil...[K]\ndu, [CS:Y]Reptain[CR], mir vertraut hast!", italian="Tu hai perso perché...[K] ti sei\nfidato di me!", spanish=" Has perdido...[K] ¡por confiar en mí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" No...[K] I don't believe that...", french=" Non...[K] Je refuse d'y croire...", german=" Nein...[K] Das glaube ich nicht...", italian=" No...[K] Non ci credo...", spanish=" No...[K] No me lo creo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I...[K]wasn't wrong...", french=" Je...[K] je ne me suis pas trompé.", german="Ich...[K] Ich habe mich\nnicht geirrt...", italian=" Io...[K] non mi sono sbagliato...", spanish=" Yo...[K] no me equivocaba..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I...[K] I still...[K]trust you...", french=" J'ai...[K] toujours confiance en toi.", german="Ich...[K] vertraue...[K]\ndir immer noch...", italian=" Ho...[K] ho ancora...[K] fiducia in te...", spanish=" Aún...[K] confío...[K] en ti..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Do my ears deceive me?!", french=" Ai-je bien entendu?!", german=" Habe ich richtig gehört?!?", italian=" Eh?! Ho capito bene?!", spanish=" ¡¿He oído bien?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(39) [anim idle native]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="HA HA HA HA![K] You\nsay that, even after all I've done...", french="HA HA HA HA![K] Après tout ce\nque j'ai fait, tu affirmes...", german="HAHAHAHA![K] Du sagst das\nnach allem, was ich dir angetan habe...", italian="AH AH AH AH AH![K] Come fai\na dire una cosa simile dopo tutto quello\nche ho fatto...?", spanish="¡Ja, ja, ja![K] ¿Dices eso después de\nlo que te he hecho?"})
  -- message_KeyWait
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" You still have trust?[K] In me?", french="... avoir toujours confiance\nen moi?", german="Du hast noch immer Vertrauen?[K]\nIn mich?", italian=" Tu hai ancora fiducia?[K] In me?", spanish=" ¿Y aún confías...[K] en mí?"})
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_PROUD_ACCOMPLISHMENT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Y-[K]yes...", french=" Eh bien...[K] oui...", german=" J-[K]ja...", italian=" S-[K]Sì...", spanish=" Sí...[K] Así es..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Despite that...[K] I know what's in\nyour heart, [K][CS:N]Dusknoir[CR]...", french="Malgré tout...[K] je sais ce qu'il y\na en ton for intérieur, [K][CS:N]Noctunoir[CR]...", german="Trotz allem...[K] weiß ich, wie\nes in deinem Herzen aussieht,[K] [CS:N]Zwirrfinst[CR]...", italian="Nonostante tutto...[K] so cosa si\ncela davvero nel tuo cuore,[K] [CS:N]Dusknoir[CR]...", spanish="A pesar de todo...[K] sé lo que hay\nen tu corazón...[K] [CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We had a moment of\nunderstanding...", french="Nous avons eu un moment\nde compréhension mutuelle...", german="Einen Moment lang\nhaben wir uns verstanden...", italian="Tra di noi si era creata\nuna reciproca intesa...", spanish="Por un momento llegamos\na entendernos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Humph. Then...[K] We had nothing\nof the kind.", french="Allons donc![K] Ce n'est qu'une vue\nde l'esprit!", german="Hmpf...[K] Einen solchen\nAugenblick gab es nicht zwischen uns.", italian="Bah...[K] Non abbiamo mai avuto\nniente di simile.", spanish="Bah. Eso crees tú...[K] No hubo nada\nde eso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ah yes.[K] I'm sure as sure can be.", french=" Non.[K] J'en suis certain.", german=" Oh doch.[K] Ich bin mir ganz sicher.", italian="Invece sì.[K] Ne sono assolutamente\nsicuro.", spanish=" Claro que sí.[K] Estoy convencido."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="While we were on our\nadventure...", french=" Pendant notre périple...", german=" Während unseres Abenteuers...", italian=" Durante la nostra avventura...", spanish=" Mientras explorábamos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="When we were pressing on\nthrough the dungeons...[K] Surmounting all\nchallenges...", french="Alors que nous enchaînions\nles donjons...[K] que nous surmontions\ntoutes les épreuves...", german="Als wir uns durch die Dungeons\nkämpften...[K] und uns all den\nHerausforderungen stellten...", italian="Mentre affrontavamo un dungeon\ndopo l'altro...[K] sconfiggendo avversari di ogni\ntipo e superando qualsiasi difficoltà...", spanish="Al avanzar por los territorios...[K]\nsuperando todos los desafíos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" While you were behind me...", french=" En ta compagnie...", german="Während du an meiner\nSeite warst...", italian=" Mentre eri vicino a me...", spanish=" Cuando íbamos codo con codo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="At some point...[K] I sensed that\nyour feelings of hatred vanished...", french="Un instant...[K] j'ai senti la haine\nte quitter...", german="Währenddessen habe ich\ngespürt,[K] wie sich deine negativen Gefühle in\nLuft auflösten...", italian="A un certo punto...[K] ho avuto\nla sensazione che il tuo odio nei miei\nconfronti fosse svanito...", spanish="Hubo un momento...[K] en que sentí\nque habías dejado de odiarme."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 200, 296, Direction.Up, "NPC_YAMIRAMI4")
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 312, 296, Direction.Up, "NPC_YAMIRAMI6")
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Left)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Wh-what are you saying?![K]\nThat's impossible!", french=" Que dis-tu?![K] Cela ne se peut!", german="W-was sagst du da?!?[K]\nDas ist unmöglich!", italian=" C-Cosa dici?![K] È impossibile!", spanish=" ¿Pero qué dices?[K] ¡Eso es imposible!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I meant what I said![K]\nI despise you!", french="Je pensais vraiment ce que\nj'ai dit![K] Je te méprise!", german="Ich meine das so, wie ich es\ngesagt habe![K] Ich verabscheue dich!", italian="Quello che ti ho detto è\nla verità![K] Io non ti sopporto!", spanish=" ¡Hablaba muy en serio![K] ¡Te odio!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" That's all you sensed!", french=" C'est tout ce que tu as ressenti!", german="Und diese Abscheu ist alles,\nwas du gespürt haben kannst!", italian="Non esiste nessun'altra\nsensazione!", spanish=" ¡No has sentido más que mi odio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I ask you to remember more\ncarefully.[K] It's not just something I sensed.", french="Souviens-toi.[K] Ce n'était pas\nune simple vue de l'esprit.", german="Versuche dich mal etwas\ngründlicher zu erinnern.[K] Es geht nicht nur\ndarum, was ich gespürt habe.", italian="Cerca di ricordare.[K] Non si tratta\nsolo di una mia sensazione.", spanish="Tendrás que recordar una cosa más.[K]\nNo se trata de imaginaciones mías."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm very cautious.", french=" Je suis très prudent.", german=" Ich bin sehr achtsam.", italian=" Io sono molto diffidente.", spanish=" Soy muy desconfiado."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And even with caution in place,\nwhile we were on this adventure together...[K]\nI decided to trust you...", french="Et malgré ma méfiance, pendant\nnotre aventure...[K] j'ai décidé de te faire\nconfiance, envers et contre tout...", german="Und trotz meiner Achtsamkeit...[K]\nentschied ich mich während unseres\nAbenteuers dafür, dir zu vertrauen...", italian="E nonostante questo, durante\nla nostra avventura...[K] ho deciso di fidarmi\ndi te...", spanish="Pese a ello, mientras explorábamos,[K]\nsentí que podía confiar en ti."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Because I could sense\nyour spirit.", french=" Car j'ai réussi à lire en toi.", german="Weil ich dein\nwahres Ich erkannte.", italian="Perché ho capito qual era la tua\nvera natura.", spanish="Porque pude percibir cómo eres\nen realidad..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...A spirit of loyalty.", french=" La loyauté qui t'habite.", german="Ein Charakter, geprägt von\nTeamgeist und Verantwortung.", italian=" Ho capito quanto tu sia leale.", spanish=" Y sé que eres leal."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I could clearly sense your spirit.[K]\nYour...[K]your shining spirit.", french="Ta[K] bonté d'âme.\nJe les ai clairement ressenties.", german="Ich habe es genau gespürt.[K]\nDein...[K] Dein wahres, edles Ich.", italian="Sono riuscito ad avvertire\nchiaramente la tua bontà.[K] La bontà...[K]\ndel tuo cuore.", spanish="Eres tremendamente leal.[K]\nEso se nota enseguida...[K] Eres así."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Sh-shine...", french=" Bonté...", german=" W-wahres...", italian=" L-La bontà...", spanish=" ¿Yo soy así?..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Shining...[K] My spirit...", french=" ... d'âme...[K] Loyauté...", german=" Edel...[K] Mein wahres Ich...", italian=" del...[K] mio cuore...", spanish=" Leal...[K] ¿De verdad?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Mine...", french=" Moi...", german=" Mein...", italian=" Il mio...", spanish=" ¿En serio?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You've pledged loyalty to Primal\n[CS:N]Dialga[CR]...", french="Tu as prêté serment\nd'allégeance à [CS:N]Dialga[CR] Primal...", german="Du hast [CS:N]Schatten-Dialga[CR] deine\nergebene Treue gelobt...", italian="Hai giurato fedeltà a [CS:N]Dialga[CR]\nOscuro...", spanish=" Juraste lealtad al [CS:N]Dialga Primario[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So you're trying to protect this\nworld of darkness.", french="Donc tu essaies de protéger\nson monde d'ombre perpétuelle.", german="Deswegen versuchst du, diese\nWelt der Dunkelheit zu beschützen.", italian="Quindi stai cercando di\nproteggere questo mondo oscuro.", spanish="Por eso intentas proteger\na toda costa este mundo de tinieblas."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But that just comes from the\ndesire not to disappear.", french="Mais seulement parce que\ntu refuses de disparaître.", german="Aber dieser Ehrgeiz nährt\nsich allein aus deiner Furcht vor\ndem möglichen Verschwinden.", italian="Ma lo fai solo perché non vuoi\nscomparire.", spanish="También cuenta sobre todo\nel deseo de no desaparecer."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But really, for you most of all,\nis that enough?", french="Entre nous, est-ce que cela\nsuffit à te satisfaire?", german="Aber ganz im Ernst,\nreicht das denn aus?", italian="Eppure ti chiedo... È questo ciò\na cui aspiri veramente?", spanish="Pero, la verdad... ¿Es eso\njustificación suficiente? Sobre todo para ti..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="To survive like this, here...[K]\nIs there any honest happiness in that for you?", french="Survivre dans ces conditions...[K]\nPeux-tu t'en contenter?", german="Nicht zu verschwinden von\ndieser dunklen Welt...[K] Ist das wirklich eine\nAussicht, für die es sich zu kämpfen lohnt?", italian="Sopravvivere in questo modo\nin un luogo simile...[K] Ti senti davvero\nfelice così?", spanish="Sobrevivir aquí, de esta forma...[K]\n¿Eso te hace feliz?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The meaning of life...[K] Think of\nwhat it truly means to live, [CS:N]Dusknoir[CR]!", french="Le sens de la vie...[K] Penses-y\nsérieusement, [CS:N]Noctunoir[CR]!", german="Der Sinn des Daseins...[K]\nDenk doch mal darüber nach, wonach es sich\nzu streben lohnt, [CS:N]Zwirrfinst[CR]!", italian="Pensa all'importanza della tua\nesistenza, [CS:N]Dusknoir[CR]...[K] Pensa al suo vero\nsignificato!", spanish="¿Qué sentido tiene este futuro?[K]\n¿Qué significa tu vida para ti, [CS:N]Dusknoir[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(80)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" What it truly means to live...", french=" Survivre dans ces conditions...", german="Wonach es sich zu\nstreben lohnt...", italian="Il vero significato della mia\nesistenza...", spanish=" ¿Qué significa realmente vivir?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" My...[K]meaning...", french=" Le sens...[K] de la vie...", german=" Der...[K] Sinn...", italian=" Il...[K] significato...", spanish=" El sentido...[K] de mi vida..."})
  -- message_Close
  GAME:FadeOut(true, 60) -- screen_WhiteOut
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
