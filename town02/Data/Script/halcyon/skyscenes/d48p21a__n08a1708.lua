-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D48P21A/n08a1708.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=47, sub=7} -- $SCENARIO_SIDE = scn[47,7] (ROM)
  -- back_SetGround(LEVEL_D48P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 248, 432, Direction.Up, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_TEMPORAL_SPIRE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 208, 288, false, 2)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 248, 288, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We've climbed pretty far...", french="Ça fait un bout de temps que\nnous marchons...", german=" Wir sind schon recht hoch...", italian=" Abbiamo fatto parecchia strada...", spanish=" Hemos subido bastante..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We're almost to the pinnacle.", french=" Nous approchons du pinacle.", german=" Die Spitze ist nicht mehr weit.", italian=" Siamo quasi arrivati in cima.", spanish=" Casi hemos llegado a la cúspide."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And there...[K] That's where Master\n[CS:N]Dialga[CR] is...", french="C'est...[K] c'est là que se trouve\nMaître [CS:N]Dialga[CR]...", german="Und dort...[K] Dort muss sich\nMeister [CS:N]Dialga[CR] aufhalten...", italian="Ed è lì...[K] che si trova il Maestro\n[CS:N]Dialga[CR]...", spanish=" Y allí...[K] es donde espera [CS:N]Dialga[CR]..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" ...[K]Hey, [CS:Y]Grovyle[CR].", french=" ...[K] Dis-moi, [CS:Y]Massko[CR].", german=" ...[K]Hey, [CS:Y]Reptain[CR].", italian=" ...[K] Ehi, [CS:Y]Grovyle[CR].", spanish=" Eh...[K] [CS:Y]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Once we've arrived at the\npinnacle...[K] Do you plan on fighting right away?", french="Une fois au pinacle...[K] comptes-tu\nengager le combat sur-le-champ?", german="Wirst du direkt zu kämpfen\nanfangen, sobald wir auf der Spitze sind?", italian="Una volta che avremo raggiunto\nla vetta...[K] hai intenzione di combattere subito?", spanish="En cuanto lleguemos a la cúspide...[K]\n¿piensas luchar inmediatamente?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I don't know if it will be right\naway or not...", french=" Aucune idée...", german="Ich weiß noch nicht, ob es\ndirekt danach sein wird...", italian=" Non lo so ancora...", spanish="No sé si será inmediatamente\no no..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The second I catch a whiff\nof trouble, I'm going to move in immediately\nto handle it.", french="Je ferai ce qu'il faut le\nmoment venu.", german="Aber bei der leisesten Ahnung\nvon Ärger werde ich einschreiten.", italian="Ma al minimo segnale di pericolo,\nnon esiterò a reagire.", spanish="En cuanto vea el menor atisbo\nde problemas, voy a tomar medidas sin perder\nun instante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But before that...[K] Could you give\nme a little time to talk to Master [CS:N]Dialga[CR]?", french="Certes, mais avant cela...[K]\nPourrais-tu me laisser un peu de temps\npour parler à Maître [CS:N]Dialga[CR]?", german="Könntest du mir davor...[K] etwas\nZeit einräumen, mit Meister [CS:N]Dialga[CR] zu reden?", italian="D'accordo. Prima però...[K] potresti\nconcedermi un po' di tempo per parlare con\nil Maestro [CS:N]Dialga[CR]?", spanish="Pero antes de eso...[K] ¿me\npermitirías hablar con [CS:N]Dialga[CR]?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I want to know Master [CS:N]Dialga[CR]'s\ntrue intentions.", french="Je veux connaître les véritables\nintentions de Maître [CS:N]Dialga[CR].", german="Ich möchte die wahren\nBeweggründe von Meister [CS:N]Dialga[CR] erfahren.", italian="Voglio scoprire le sue vere\nintenzioni.", spanish="Quiero conocer sus auténticas\nintenciones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" No way![K] If you talk to [CS:N]Dialga[CR]...", french="Hors de question![K] Si tu parles\nà [CS:N]Dialga[CR]...", german="Auf keinen Fall![K] Wenn du erst\nmit [CS:N]Dialga[CR] sprichst...", italian="Assolutamente no![K] Se parlassi\ncon [CS:N]Dialga[CR]...", spanish=" ¡Ni hablar![K] Si hablas con [CS:N]Dialga[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Then you'll probably begin to\nside with [CS:N]Dialga[CR]!", french="... tu finiras sans doute par\nretourner ta veste!", german="Dann wirst du\nhöchstwahrscheinlich die Seite\nwechseln und [CS:N]Dialga[CR] verteidigen!", italian="... molto probabilmente ti\nschiereresti di nuovo dalla sua parte!", spanish="¡No tardarás en ponerte de su lado!\n¡Bastante tengo con luchar contra [CS:N]Dialga[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Besides, the new henchman will\nlikely be there as well.", french="Par ailleurs, le nouveau bras\ndroit sera sûrement là, lui aussi.", german="Darüber hinaus dürfte der neue\nGehilfe auch da sein.", italian="Inoltre potrebbe esserci anche\nil nuovo servitore.", spanish="Además, seguramente tu sustituto\ntambién estará allí."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And then it will be three on one![K]\nThe chances of me winning are slim to none!", french="Et alors, ce sera du trois contre\nun![K] Je n'ai presque aucune chance de gagner!", german="Das wäre ein Kampf von drei\ngegen einen![K] Meine Gewinnchancen wären\nalso verschwindend gering!", italian="E a quel punto dovrei affrontare\ntre avversari da solo![K] Le mie possibilità\ndi farcela sarebbero ridotte a zero!", spanish="¡Y seréis tres contra uno![K]\n¡Dime tú a mí cómo os voy a vencer!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Humph.[K] I at least...", french=" Pfff.[K] N'aie crainte...", german=" Hmpf.[K] Ich für meinen Teil...", italian=" Bah.[K] Comunque io...", spanish=" ¡Ja![K] Yo al menos..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I don't plan on making friends\nwith the new henchman.", french="... je n'ai aucune intention de\nm'acoquiner avec le nouveau bras droit.", german="Ich habe nicht vor, mich mit\ndem neuen Gehilfen zu verbünden.", italian="... non ho nessuna intenzione\ndi allearmi con il nuovo servitore.", spanish="No tengo pensado trabar amistad\ncon ese tipo."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" ...[K]Fine.", french=" ...[K] Mais comme tu voudras.", german=" ...[K]Gut.", italian=" ...[K] D'accordo.", spanish=" Vale...[K] Allá tú."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I won't fight by your side on\nthe pinnacle.", french="Ne compte pas sur moi pour\nme battre à tes côtés au pinacle.", german="Ich werde auf der Spitze aber\nnicht an deiner Seite kämpfen.", italian="Quando arriveremo in cima,\nnon lotterò al tuo fianco.", spanish="No voy a luchar contigo en\nla cúspide."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="After you fight Master [CS:N]Dialga[CR]...[K]\nAnd once you are defeated...", french="Après ton combat contre Maître\n[CS:N]Dialga[CR]...[K] quand il t'aura réduit en miettes...", german="Nachdem du mit Meister [CS:N]Dialga[CR]\ngekämpft hast...[K] Und nachdem du\nbesiegt wurdest...", italian="Dopo che avrai affrontato\nil Maestro [CS:N]Dialga[CR]...[K] e sarai stato sconfitto...", spanish="Esperaré a que te enfrentes a\n[CS:N]Dialga[CR]...[K] Y en cuanto te derrote..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I will ask Master [CS:N]Dialga[CR].", french=" ... je lui poserai la question.", german="Ich werde schon ausreichend\nZeit haben, Meister [CS:N]Dialga[CR] zu befragen.", italian=" Parlerò con lui.", spanish="Tendré tiempo de sobra para\npreguntarle a [CS:N]Dialga[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Humph.[K] Do whatever you want!", french=" Pfff.[K] Si ça te chante!", german="Hmpf.[K]\nMach doch, was immer du willst!", italian=" Bah.[K] Fa' come vuoi!", spanish=" ¡Bah![K] ¡Haz lo que te dé la gana!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
