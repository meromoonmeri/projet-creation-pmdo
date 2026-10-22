-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D52P11A/n09a0907.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D52P11A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 240, 272, Direction.Up, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(36) [anim idle native]
  -- SetAnimation(27) [anim idle native]
  local npc_npc_yukiwarashi = SkySceneKit.spawn_npc("snorunt", 320, 256, Direction.Up, "NPC_YUKIWARASHI")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- GAP: se_Play(10762) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(280, 252, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" The pillar's electricity...", french=" L'électricité des piliers...", german=" Die Elektrizität auf der Säule...", italian="L'elettricità che attraversa\nquella colonna...", spanish=" La electricidad de las columnas..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Has gotten pretty intense...", french=" Elle s'intensifie...", german=" Sie hat deutlich zugenommen...", italian=" ... è diventata molto intensa...", spanish=" Ahora es mucho más intensa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yukiwarashi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Har har...[K] Har ha ha har!", french=" Gnii...[K] Gnignignii!!", german=" Harha...[K] Haharhar!!!", italian=" Eh-eh...[K] Eh-eh-eh-eh!!!", spanish=" Ay, ay...[K] ¡Ay, ay, ay...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  GAME:WaitFrames(20)
  do local p=npc_npc_yukiwarashi.Position; GROUND:MoveToPosition(npc_npc_yukiwarashi, p.X+(120), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(32), p.Y+(0), false, 2) end
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh! Hey!", french=" Hé!", german=" Oh! Hey!", italian=" Oh! Ehi!", spanish=" ¡Ah! ¡Vaya!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(10762, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(45)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" ...[K]It looks like it's calmed down...", french="...[K] Il semblerait que cela\nse calme...", german="...[K]Sieht fast so aus,\nals ob sie sich beruhigt hat...", italian=" ...[K] Pare che sia diminuita...", spanish=" Oh...[K] Parece que se ha calmado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(36) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(90)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hey...[K] What is with him all\nof a sudden...?", french="Hé...[K] Qu'est-ce qui lui a pris,\ntout à coup...?", german="Hey...[K] Was ist denn plötzlich\nmit ihm los?", italian="Ehi...[K] Ma cosa gli è successo\ntutto a un tratto...?", spanish=" Eh...[K] ¿Qué le ha pasado de repente?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(16), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Icicle Forest.ogg", true) end)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="At any rate...[K] [CS:N]Celebi[CR] and the\n[CS:N]Sableye[CR] should be up ahead.", french="Quoi qu'il en soit...[K] [CS:N]Celebi[CR] et les\n[CS:N]Ténéfix[CR] sont devant.", german="Wie auch immer...[K] [CS:N]Celebi[CR] und die\n[CS:N]Zobiris[CR] müssten kurz vor uns sein.", italian="In ogni caso...[K] [CS:N]Celebi[CR] e i [CS:N]Sableye[CR]\ndovrebbero essere poco più avanti.", spanish="El caso es que...[K] [CS:N]Celebi[CR] y los [CS:N]Sableye[CR]\ntienen que estar delante de nosotros."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I couldn't get [CS:N]Snorunt[CR]\nto confirm it...", french=" [CS:N]Stalgamin[CR] ne l'a pas confirmé...", german="Ich konnte zwar keine\nBestätigung mehr von [CS:N]Schneppke[CR] bekommen...", italian="Non sono riuscito a bloccare\n[CS:N]Snorunt[CR] per avere una conferma...", spanish="No he conseguido que [CS:N]Snorunt[CR]\nlo confirme..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But there's a good chance that\nMaster [CS:N]Dialga[CR] and his new henchman\nwill be there.", french="... mais il y de grandes chances\nque Maître [CS:N]Dialga[CR] soit là aussi avec son\nnouveau bras droit.", german="Aber die Chancen stehen gut,\ndass Meister [CS:N]Dialga[CR] und sein\nneuer Gehilfe dort sind.", italian="Ma ci sono buone probabilità che\nil Maestro [CS:N]Dialga[CR] e il suo nuovo servitore\nsi trovino laggiù.", spanish="Pero es muy probable que [CS:N]Dialga[CR]\ny mi sustituto estén ahí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah.[K] That was our first clue.", french="Ouais.[K] Nous sommes sur\nleur piste.", german="Ja.[K]\nDas war ein erster guter Hinweis.", italian=" Sì.[K] Come pensavamo.", spanish=" Sí.[K] Esa fue nuestra primera pista."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We won't let them get away!", french=" Ne les laissons pas nous semer!", german="Wir werden sie\nnicht entkommen lassen!", italian=" Non dobbiamo farceli sfuggire!", spanish=" ¡No dejaremos que se escapen!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Focus, and let's go!", french=" Concentrons-nous et partons!", german=" Knöpfen wir sie uns mal vor!", italian=" Prepariamoci e andiamo!", spanish=" ¡Céntrate, y sigamos!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
