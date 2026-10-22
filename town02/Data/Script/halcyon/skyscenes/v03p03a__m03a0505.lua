-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P03A/m03a0505.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V03P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 304, 144, Direction.Left, "NPC_DAGUTORIO")
  GROUND:MoveToPosition(npc_npc_dagutorio, 176, 140, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Bidoof", true, "bidoof", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_BIPPA) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Updating data is [CS:N]Dugtrio[CR]'s duty.", french="La mise à jour des tableaux, ça\nfait partie du travail de [CS:N]Triopikeur[CR].", german="Die Aktualisierung der Daten ist\ndie Aufgabe von [CS:N]Digdri[CR].", italian="Aggiornare i dati è compito di\n[CS:N]Dugtrio[CR].", spanish="[CS:N]Dugtrio[CR] se encarga de mantener\nlas listas al día."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" He tunnels his way to our guild...", french="Il creuse des tunnels pour\ns'déplacer dans la Guilde...", german=" Er gräbt sich zur Gilde durch...", italian=" Si sposta attraverso dei tunnel...", spanish="Hace un túnel para llegar\nhasta el [CS:N]Pokégremio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6416) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V03P03A1_209) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_oosubame = SkySceneKit.spawn_npc("swellow", 88, 136, Direction.Right, "NPC_OOSUBAME")
  pcall(function() GROUND:CharSetEmote(npc_npc_oosubame, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  local npc_npc_kemusso = SkySceneKit.spawn_npc("wurmple", 88, 160, Direction.Right, "NPC_KEMUSSO")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_oosubame, npc_npc_kemusso, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kemusso, npc_npc_oosubame, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_oosubame, "sweating", 1) end)
  GAME:WaitFrames(10)
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "sweating", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Then he flips the panel and\nupdates the data.", french="... et puis il retourne l'panneau\net met les infos à jour.", german="Dann dreht er das Brett um und\naktualisiert die Daten.", italian="... poi capovolge il pannello e\naggiorna i dati.", spanish="Entonces le da la vuelta\nal panel y pone al día los tablones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_oosubame, "sweating", 1) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  -- GAP: se_Play(6416) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V03P03A1_209) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_oosubame, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_oosubame, Direction.Right)
  GROUND:EntTurn(npc_npc_kemusso, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:MoveToPosition(npc_npc_dagutorio, 304, 140, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_oosubame, "sweatdrop", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "sweatdrop", 1) end)
  GAME:WaitFrames(15)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="This duty doesn't get noticed\nmuch, but it's very important. Yup yup!", french="Son travail est pas vraiment\nremarqué, mais il est vachement important.\nPour sûr!", german="Seine Aufgabe wird zwar kaum\nwahrgenommen, aber sie ist sehr wichtig.\nJawollja!", italian="Non tutti sanno di questa sua\nattività, ma è un compito molto, molto\nimportante. Eh sì!", spanish="Esta tarea casi pasa\ndesapercibida, pero es muy importante."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That's why [CS:N]Dugtrio[CR] takes such\ngreat pride in the duty he does!", french="C'est pour ça que [CS:N]Triopikeur[CR],\nil est vachement fier d'son travail!", german="Darum ist [CS:N]Digdri[CR] auch mächtig\nstolz auf seine Aufgabe!", italian="È per questo che [CS:N]Dugtrio[CR] va così\nfiero di ciò che fa!", spanish="Por eso [CS:N]Dugtrio[CR] está tan\norgulloso de su labor. ¡Sí, señor!"})
  -- message_Close
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
