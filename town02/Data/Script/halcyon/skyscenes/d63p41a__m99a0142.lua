-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D63P41A/m99a0142.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(104, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D63P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_WELCOME_TO_THE_WORLD_OF_POKEMON non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 228, 300, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 228, 192, false, 2)
  pcall(function() GAME:MoveCamera(228, 192, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] examined the statue!", french="[CN][player] examine la statue!", german="[CN][player] untersucht\n[CN]die Statue!", italian="[CN][player] ha esaminato la statua!", spanish="[CN][player] ha examinado la estatua."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]\n[CN]\"Across time and space...one heart...\"", french="[CN]\n[CN]\"A travers le temps et l'espace... un cœur...\"", german="[CN]\n[CN][F:S2]Durch Raum und Zeit... Ein Herz...[F:E2]", italian="[CN]\n[CN]\"Attraverso il tempo e lo spazio... un cuore...\"", spanish="[CN]\n[CN]\"Por el espacio y el tiempo... un corazón...\""})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Is this the Legendary Pokémon [CS:N]Arceus[CR]\nwho created everything...?)", french="(S'agit-il du Pokémon Légendaire [CS:N]Arceus[CR],\nle créateur de toute chose...?)", german="(Ist das [CS:N]Arceus[CR], das Legendäre Pokémon,\ndas alles erschaffen hat?)", italian="(Che si tratti del Pokémon leggendario [CS:N]Arceus[CR],\ncolui che ha dato origine a ogni cosa...?)", spanish="(¿Será este el Pokémon Legendario [CS:N]Arceus[CR],\nque lo creó todo...?)"})
  -- message_Close
  GAME:WaitFrames(20)
  -- GAP: se_Play(8194) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect EFFECT_LIGHT_ENGULFING2 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:WaitFrames(10)
  -- MovePositionMark OBJECT_D63P41A2_566 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D63P41A2_566) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(20)
  -- item_Set(0, 43, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_GIVE_ITEM"] or 0) -- switch(message_Menu(MENU_GIVE_ITEM)) [message_Menu(MENU_GIVE_ITEM): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][player] has cleared\n[CN][CS:P]Destiny Tower[CR]!", french="[CN][player] a terminé\n[CN]la [CS:P]Tour du Destin[CR]!", german="[CN][player] meisterte den\n[CN][CS:P]Verhängnisturm[CR]!", italian="[CN][player] ha completato\n[CN]la [CS:P]Torre Destino[CR]!", spanish="[CN][player] ha atravesado con éxito la\n[CN][CS:P]Torre Destino[CR]."})
  -- message_Close
  elseif true then -- default
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayFanfare("Fanfare/Treasure") end) -- me_Play(9) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][player] obtained the\n[CN][s_item:0]!", french="[CN][player] reçoit l'objet\n[CN][s_item:0]!", german="[CN][player] erhält das Item\n[CN][s_item:0]!", italian="[CN][player] ha ottenuto lo strumento\n[CN][s_item:0]!", spanish="[CN]¡[player] ha obtenido el objeto\n[CN][s_item:0]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
