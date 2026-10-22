-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D22P11A/n08a2008.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D22P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D22P11A, 'UN08') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 296, 408, Direction.Up, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DUSK_FOREST non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 252, 264, false, 2)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 296, 264, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ... ([CS:N]Celebi[CR]...)", french=" ... ([CS:N]Celebi[CR]...)", german=" ...([CS:N]Celebi[CR]...)", italian=" ... ([CS:N]Celebi[CR]...)", spanish=" Ah... ([CS:N]Celebi[CR]...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Left)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:Y]Grovyle[CR].", french=" [CS:Y]Massko[CR].", german=" [CS:Y]Reptain[CR].", italian=" [CS:Y]Grovyle[CR].", spanish=" [CS:Y]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="No matter what, she's up against\nMaster [CS:N]Dialga[CR].", french="A l'heure actuelle, elle est\naux prises avec Maître [CS:N]Dialga[CR].", german="Was auch geschieht, es wird\nvon Meister [CS:N]Dialga[CR] aufgespürt werden.", italian="Non c'è niente da fare, ormai\nil Maestro [CS:N]Dialga[CR] è sulle sue tracce.", spanish="El caso es que ella se enfrenta\na [CS:N]Dialga[CR]."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But we're most likely already\ntoo late.", french=" Sans doute est-il déjà trop tard.", german="Und höchstwahrscheinlich sind\nwir bereits zu spät, um noch eingreifen\nzu können.", italian="Probabilmente è già troppo\ntardi per lei.", spanish="Probablemente ya sea demasiado\ntarde para hacer nada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Shut up, [CS:N]Dusknoir[CR]!", french=" La ferme, [CS:N]Noctunoir[CR]!", german=" Sei still, [CS:N]Zwirrfinst[CR]!", italian=" Zitto, [CS:N]Dusknoir[CR]!", spanish=" ¡Cállate, [CS:N]Dusknoir[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="She wouldn't be caught\nthat easily!", french="Elle n'est pas si facile\nà capturer!", german="So leicht wird es\nnicht zu fangen sein!", italian="Non è tipo da farsi catturare\ncosì facilmente!", spanish="¡Ella no se dejará atrapar\ntan fácilmente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (That's right![K] [CS:N]Celebi[CR]'s\nnot weak!)", french="... (C'est vrai![K] [CS:N]Celebi[CR] n'a rien\nd'un Pokémon sans défense!)", german="...(Das stimmt nun wirklich![K]\n[CS:N]Celebi[CR] ist kein schwaches Pokémon!)", italian="... (Giusto![K] [CS:N]Celebi[CR] non è così\ndebole!)", spanish="Oh... (¡Por supuesto que no![K]\n¡[CS:N]Celebi[CR] no es precisamente débil!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (But!)", french=" (Cela dit...)", german=" (Aber!)", italian=" (Però...)", spanish=" (Ah, pero...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(As [CS:N]Dusknoir[CR] said...[K]\nShe's up against Primal [CS:N]Dialga[CR]!)", french="(Comme l'a dit [CS:N]Noctunoir[CR]...[K]\nc'est à [CS:N]Dialga[CR] Primal qu'elle a affaire!)", german="(Genau wie [CS:N]Zwirrfinst[CR] sagte...[K]\nEs wird von [CS:N]Schatten-Dialga[CR] verfolgt!)", italian="(Come ha detto [CS:N]Dusknoir[CR]...[K]\ndeve vedersela con [CS:N]Dialga[CR] Oscuro!)", spanish="(Tal como ha dicho [CS:N]Dusknoir[CR]...[K]\n¡se enfrenta al [CS:N]Dialga Primario[CR]!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(And the resourceful new\nhenchman too!)", french="(Et au nouveau bras droit\naux multiples talents!)", german="(Und außerdem von dem neuen,\neinfallsreichen Gehilfen!)", italian="(E anche con quel nuovo\nservitore che pare sia molto potente!)", spanish="(¡Y a su nueva mano derecha,\ntan competente y con tantos recursos!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(The last time I fought [CS:N]Dusknoir[CR]\nin [CS:P]Deep Dusk Forest[CR], we weren't too far\nfrom here.)", french="(J'ai déjà affronté [CS:N]Noctunoir[CR]\nau cœur de la [CS:P]Forêt Crépuscule[CR],\nce n'était pas très loin d'ici.)", german="(Das letzte Mal, als ich gegen\n[CS:N]Zwirrfinst[CR] im [CS:P]Tiefen Düsterwald[CR] gekämpft\nhabe, waren wir gar nicht so weit von hier.)", italian="(L'ultima volta che ho lottato\ncontro [CS:N]Dusknoir[CR] mi trovavo nella [CS:P]Selva[CR]\n[CS:P]Oscura[CR], non lontano da qui.)", spanish="(La última vez que luché con\n[CS:N]Dusknoir[CR] en el [CS:P]Corazón Bosque Sombrío[CR]\nno estábamos muy lejos de esta zona.)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(I think [CS:N]Celebi[CR] would be on the\nlookout and would have left there by now...)", french="([CS:N]Celebi[CR] devait être sur\nses gardes. Elle a sûrement quitté\nles lieux, à l'heure qu'il est...)", german="(Möglicherweise war [CS:N]Celebi[CR]\nvorsichtig und ist bereits geflohen...)", italian="(Credo che [CS:N]Celebi[CR] abbia fiutato\nil pericolo e si sia già messa in salvo...)", spanish="(Supongo que [CS:N]Celebi[CR] estará\nprevenida, y ya se habrá marchado...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="([CS:N]Celebi[CR]...[K] [CS:N]Celebi[CR]...[K]\nI'm begging you...)", french="([CS:N]Celebi[CR]...[K] [CS:N]Celebi[CR]...[K]\nJe t'en supplie...)", german="([CS:N]Celebi[CR]...[K] [CS:N]Celebi[CR]...[K]\nIch flehe dich an...)", italian=" ([CS:N]Celebi[CR]...[K] [CS:N]Celebi[CR]...[K] Oh, ti prego...)", spanish=" ([CS:N]Celebi[CR]...[K] [CS:N]Celebi[CR]...[K] Te lo ruego...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (Keep yourself safe!)", french=" (Fais attention à toi!)", german=" (Pass gut auf dich auf!)", italian=" (Spero che tu stia bene!)", spanish=" (¡Mantente a salvo!)"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
