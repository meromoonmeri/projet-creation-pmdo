-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P42A/n01a3001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(127, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D42P42A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 252, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hey! [CS:N]Jirachi[CR]![K]\nI've come back, yup yup!", french="Ohé! [CS:N]Jirachi[CR]![K]\nMe r'voilà, pardi!", german="Hey! [CS:N]Jirachi[CR]![K]\nDa bin ich wieder, jawollja!", italian="Ehi! [CS:N]Jirachi[CR]![K]\nSono tornato, già, già!", spanish="¡Eh, [CS:N]Jirachi[CR]![K]\n¡He vuelto, sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...Yaaaaaawwwwwnnnn...", french=" ... Ouuuuuuaaaaaah...", german=" ...Gäääääääähn...", italian=" ... Yaaaaaawwwwwwnnn...", spanish=" Aaaaaaaahm..."})
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm sleeeeeepy...[K] Yaaaaawn...", french=" Siiiii fatigué...[K] Ouuuaaah...", german=" Ich bin müüüüüde...[K] Gääääähn...", italian=" Ho sooonnoooooo...[K] Yaaaaaawn...", spanish=" Tengo sueeeeeeñooo...[K] Uaaaa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  -- GAP: se_Play(9224) — id SE NDS sans portage PMDO identifié
  local npc_npc_jiraachi = SkySceneKit.spawn_npc("jirachi", 256, 224, Direction.Down, "NPC_JIRAACHI")
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(43) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_BEYOND_THE_DREAM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="I'm [CS:N]Jirachi[CR].[K]\nWho are you? Zzzz... Snorf...", french="Je suis [CS:N]Jirachi[CR].[K]\nQui es-tu? Zzzz... ron...", german="Ich bin [CS:N]Jirachi[CR].[K]\nWer bist du? Zzzzzz... Schnrmpf...", italian="Io sono [CS:N]Jirachi[CR].[K]\nE tu chi sei? Zzz... Ronf...", spanish="Soy [CS:N]Jirachi[CR].[K]\n¿Tú quién eres? Zzzz... Groonf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm [CS:Y]Bidoof[CR].[K] (That's what I've\nbeen telling you since the beginning...)", french="J'suis [CS:Y]Keunotor[CR].[K] (Il est bouché,\nma parole, j'arrête pas d'lui dire...)", german="Ich bin [CS:Y]Bidiza[CR].[K]\n(Merk dir das endlich mal...)", italian="Mi chiamo [CS:Y]Bidoof[CR].[K] (È dall'inizio\nche mi chiede sempre la stessa cosa...)", spanish="Soy [CS:Y]Bidoof[CR].[K] (Me da que tiene\nun ligero problema de memoria...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="Hmmm...[K] I'm still so sleeeepy...\nYaaaaawn...", french="Mmmh...[K] Encore siiiiii fatigué...\nOuuuuaaaah...", german="Hmmmmmmm...[K] Immer noch so\nmüüüüüüde... Gäääääähn...", italian="Mmmh...[K] Ho ancora tanto\nsooonnooo... Yaaaaaawn...", spanish="Hum...[K] Sigo teniendo sueñooo...\nAaaaahm..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="I tend to act strangely when I\nsleep and cause trouble all around me, so I\napologize again... Zzzz... Snorf...", french="J'ai tendance à faire de drôles\nde choses dans mon sommeil et ça peut faire\ndes dégâts, alors, encore désolé... Zzz... ron...", german="Ich neige dazu, mich im Schlaf\nsonderbar zu benehmen und ganz schön was\nanzurichten. Entschuldige... Zzzz... Schnrmpf...", italian="Quando dormo mi capita di\nagire in maniera strana e combinare dei guai,\nquindi ti chiedo di nuovo scusa... Zzzz... Ronf...", spanish="Suelo actuar de forma extraña y\ndar problemas cuando duermo, pero no lo hago\naposta, lo siento... Zzzz... Groonf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Ugh...\n(I thought this before, yup yup...)", french="Argh...\n(J'm'en étais rendu compte, pardi...)", german="Uff...\n(Na, lieber spät als gar nicht, jawollja...)", italian="Urgh...\n(Già lo sapevo, ohibò...)", spanish="Uf... (Pues menos mal que\nlo hace sin querer, porque suelta cada leche...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (He isn't really\nasleep, is he...? Sniff...)", french="... (Mais y dort pas pour\nde vrai, si...? Snif...)", german="...(Schläft es überhaupt\nwirklich? Schnief...)", italian="(Ma sta davvero dormendo o fa\nsolo finta...? Sniff...)", spanish="Jo... (A ver si me la está dando\ncon queso con eso de que duerme... Snif...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" Ready...? Zzzz... Snorf...", french=" Prêt...? Zzzz... ron...", german=" Bereit? Zzzz... Schnrmpf...", italian=" Sei pronto...? Zzzz... Ronf...", spanish=" ¿Estás listo...? Zzzz... Groonf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(127, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
