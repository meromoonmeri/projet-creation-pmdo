-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D22P11A/n08a2408.ssb (ROM sha256 1fa39d35…).
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
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 296, 264, Direction.Left, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DUSK_FOREST non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" That was close.", french=" Nous avons eu chaud.", german=" Das war knapp.", italian=" C'è mancato poco.", spanish=" Ha faltado poco."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="However...[K] If the [CS:N]Sableye[CR]\nset a trap over there...", french="Toutefois...[K] si les [CS:N]Ténéfix[CR]\nnous ont tendu un piège en ce lieu...", german="Aber...[K] Wenn die [CS:N]Zobiris[CR]\ndort eine Falle gelegt haben...", italian="In ogni caso...[K] se i [CS:N]Sableye[CR]\nci hanno teso un'imboscata in quel luogo...", spanish="Entonces...[K] Si los [CS:N]Sableye[CR]\nhan tendido una trampa en ese sitio..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I know.[K] [CS:N]Celebi[CR] isn't\nthere anymore.", french="Je sais.[K] C'est que [CS:N]Celebi[CR]\nn'est plus là.", german="Ich weiß.[K]\n[CS:N]Celebi[CR] ist nicht mehr hier.", italian="Lo so.[K] Vuol dire che [CS:N]Celebi[CR] non\nè più lì.", spanish="Ya lo sé.[K] [CS:N]Celebi[CR] ya no está\nallí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But you're still going,\naren't you?[K] On from here.", french="Mais tu vas tout de même\ncontinuer, n'est-ce pas?[K] A partir d'ici.", german="Aber du machst weiter, oder?[K]\nVon hier aus.", italian="Ma tu non hai intenzione di\narrenderti, vero?[K] Andrai avanti.", spanish="Pero eso no te detendrá, ¿verdad?[K]\nPiensas seguir adelante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah.", french=" Exact.", german=" Ja.", italian=" Sì.", spanish=" En efecto."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Knock out the [CS:N]Sableye[CR]...[K]\nOr get some information out of them!", french="Je vais éliminer les [CS:N]Ténéfix[CR]...[K]\nOu leur tirer les vers du nez!", german="Mach die [CS:N]Zobiris[CR] fertig...[K]\nOder hol wenigstens einige Informationen\naus ihnen raus!", italian="Sconfiggerò i [CS:N]Sableye[CR]...[K]\nE li costringerò a parlare!", spanish="Acabaré con los [CS:N]Sableye[CR]...[K]\n¡O me darán la información que necesito!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" To find [CS:N]Celebi[CR] and [CS:N]Dialga[CR]!", french=" Pour retrouver [CS:N]Celebi[CR] et [CS:N]Dialga[CR]!", german="Damit wir [CS:N]Celebi[CR]\nund [CS:N]Dialga[CR] finden!", italian="Per scoprire dove si trovano\n[CS:N]Celebi[CR] e [CS:N]Dialga[CR]!", spanish="¡Así encontraré a [CS:N]Celebi[CR] y\na [CS:N]Dialga[CR]!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
