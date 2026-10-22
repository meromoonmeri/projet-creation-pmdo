-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P41A/s31a3401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 30) -- $SCENARIO_MAIN = scn[29,30] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(122, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 256, 392, Direction.Up, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Oh! I can see it! The summit!", french=" Oh! Je le vois! Le sommet!", german=" Oh! Ich kann den Gipfel sehen!", italian=" Oh! Eccola! Vedo la cima!", spanish=" ¡Eh, ya la veo, ahí está la cima!"})
  -- message_Close
  -- back_SetGround(LEVEL_D73P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- back_SetWeather(11) [météo visuelle ground NDS - documenté]
  -- supervision_SpecialActing(34, 0, 0) [cadrage NDS]
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(npc_npc_sheimi, 252, 316, false, 2)
  GROUND:MoveToPosition(hero, 252, 340, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 276, 332, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 228, 332, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_sheimi, 252, 236, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 252, 260, false, 2)
  GAME:WaitFrames(15)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 276, 252, false, 2) end end
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 228, 252, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Th-this is...terrible...", french=" Qu-quelle... catastrophe...", german=" D-das ist... übel...", italian=" M-Ma è... terribile...", spanish=" Esto... Esto es... terrible..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="All this happened while I was\naway for so long...", french="Tout ça est arrivé pendant ma\nlongue absence...", german="Anscheinend ist das alles\nwährend meiner Abwesenheit geschehen...", italian="Tutto questo è accaduto durante\nla mia lunga assenza...", spanish="Y todo esto ha sucedido durante\nmi larga ausencia..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 280, 424, Direction.Up, "NPC_KINOGASSA")
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end) -- message_SetActor(ACTOR_NPC_KINOGASSA)
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Looks like someone else got\nhere first...", french="Tiens, on n'est pas\nles premiers...", german="Sieht so aus, als ob jemand vor\nuns hier war...", italian="Sembra che qualcuno\nsia arrivato prima di noi...", spanish="Parece que alguien ha llegado\naquí antes..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(3)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(3)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(4)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Down) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Down) end end
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 256, 384, Direction.Up, "NPC_GOORIKII")
  GROUND:MoveToPosition(npc_npc_goorikii, 252, 332, false, 2)
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 232, 408, Direction.Up, "NPC_KUCHIITO")
  GROUND:MoveToPosition(npc_npc_kuchiito, 228, 332, false, 2)
  GROUND:MoveToPosition(npc_npc_kinogassa, 276, 332, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_goorikii, 252, 288, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_kuchiito, 228, 288, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_kinogassa, 276, 288, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" ...but what is this?!", french=" Mais qu'est-ce que ceci?!", german=" ...Aber was ist das?!?", italian=" ... Ma cos'è questo?!", spanish=" ¡¿Pero... esto qué es?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" Th-this is the summit?", french=" C'est... c'est le sommet?", german=" D-das ist also der Gipfel?", italian=" S-Siamo davvero in cima?", spanish=" ¿Esto... es la cima?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" No, this is...", french=" Non, c'est...", german=" Nein, das ist...", italian=" No, questo è...", spanish=" No, esto es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Icky, sticky...grimy, slimy...", french="Graicheux, poicheux...\ncracheux, vichqueux...", german=" Kleb, ekel... Schmutzig, schleimig...", italian=" Sguish, sguosh... Smelm, sblosh...", spanish="Asqueroso, pegajoso... pringoso,\nviscoso..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" We loooove dirt and slime...", french=" On ch'ébroue dans la bouuue...", german=" Wir liiieben Dreck und Schleim...", italian="Adoriamo il faaaaaango\ne il viscidume...", spanish=" Nos encanta la suciedad y la mugre..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "exclaim", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "exclaim", 1) end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(3)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  -- GAP: se_Play(11011) — id SE NDS sans portage PMDO identifié
  local npc_npc_betobetaa3 = SkySceneKit.spawn_npc("grimer", 120, 376, Direction.Down, "NPC_BETOBETAA3")
  GROUND:MoveToPosition(npc_npc_betobetaa3, 204, 300, false, 2)
  local npc_npc_betobetaa5 = SkySceneKit.spawn_npc("grimer", 392, 376, Direction.Down, "NPC_BETOBETAA5")
  GROUND:MoveToPosition(npc_npc_betobetaa5, 300, 300, false, 2)
  GAME:WaitFrames(20)
  local npc_npc_betobetaa = SkySceneKit.spawn_npc("grimer", 200, 160, Direction.Down, "NPC_BETOBETAA")
  GROUND:MoveToPosition(npc_npc_betobetaa, 220, 212, false, 2)
  local npc_npc_betobetaa2 = SkySceneKit.spawn_npc("grimer", 312, 160, Direction.Down, "NPC_BETOBETAA2")
  GROUND:MoveToPosition(npc_npc_betobetaa2, 284, 212, false, 2)
  local npc_npc_betobetaa4 = SkySceneKit.spawn_npc("grimer", 256, 400, Direction.Down, "NPC_BETOBETAA4")
  GROUND:MoveToPosition(npc_npc_betobetaa4, 252, 308, false, 2)
  local npc_npc_betobeton = SkySceneKit.spawn_npc("muk", 256, 152, Direction.Down, "NPC_BETOBETON")
  GROUND:MoveToPosition(npc_npc_betobeton, 252, 204, false, 2)
  local npc_npc_betobeton2 = SkySceneKit.spawn_npc("muk", 112, 208, Direction.Down, "NPC_BETOBETON2")
  GROUND:MoveToPosition(npc_npc_betobeton2, 188, 252, false, 2)
  local npc_npc_betobeton3 = SkySceneKit.spawn_npc("muk", 400, 216, Direction.Down, "NPC_BETOBETON3")
  GROUND:MoveToPosition(npc_npc_betobeton3, 324, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_sheimi, Direction.Up)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(3)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Left) end end
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_kuchiito, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_kinogassa, Direction.DownRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_goorikii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(4)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(6)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(6)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kuchiito, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(4)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Left) end end
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_kinogassa, Direction.DownRight)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_kinogassa.Position; GROUND:MoveToPosition(npc_npc_kinogassa, p.X+(0), p.Y+(-4), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_kuchiito.Position; GROUND:MoveToPosition(npc_npc_kuchiito, p.X+(0), p.Y+(-4), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_goorikii.Position; GROUND:MoveToPosition(npc_npc_goorikii, p.X+(0), p.Y+(-4), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" Wh-what...?!", french=" Qu-quoi...?!", german=" W-waaas?!?", italian=" C-Cosa...?!", spanish=" ¡¿Pero... qué...?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="A group of [CS:N]Grimer[CR] and [CS:N]Muk[CR].\nThis isn't your home, you know that...", french="Des [CS:N]Tadmorv[CR] et [CS:N]Grotadmorv[CR]...\nVous n'avez rien à faire ici, vous le\nsavez parfaitement.", german="[CS:N]Sleima[CR] und [CS:N]Sleimok[CR]!\nIhr gehört hier nicht her, das wisst ihr doch...", italian="[CS:N]Grimer[CR], [CS:N]Muk[CR].\nVoi non potete stare qui, lo sapete...", spanish="[CS:N]Grimer[CR] y [CS:N]Muk[CR]...\nEste no es vuestro hogar, ya lo sabéis..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Please, go back where\nyou belong.", french="Retournez dans votre habitat\nnaturel, s'il vous plaît.", german="Ich bitte euch, geht zurück,\nwo ihr hingehört.", italian="Per favore, tornate da dove\nsiete venuti.", spanish="Volved a vuestro hogar,\npor favor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11012) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_betobetaa2, Direction.DownRight)
  GROUND:EntTurn(npc_npc_betobetaa2, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_betobetaa2, Direction.DownRight)
  GROUND:EntTurn(npc_npc_betobetaa2, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_betobetaa2, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" No. Nooooooooo.", french=" Non. Nooooooooonch.", german=" Nein. Neiiiiin.", italian=" No... Nooooooooo!", spanish=" No. Nooooooooo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11012) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_betobetaa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_betobetaa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_betobetaa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_betobetaa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_betobetaa, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_betobetaa) end)
  SkySceneKit.say({english=" Lies. Liiiiiiiies.", french="Menchonges.\nQueeee des menchonges.", german=" Lügen. Lüüüüügen.", italian=" Bugie... Bugiiiiiiiiie!", spanish=" Mentiras. Mentiraaassss."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11013) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_betobeton) end)
  SkySceneKit.say({english=" We drive away cleanlinessss!", french="On chalit touuuut ch'qui\nest propre!", german=" Weg mit der Sssauberkeit!", italian="Noi siamo i nemici della\npuliziiiiiia!", spanish=" ¡Odiamosssss la limpieza!"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_FacePositionOffset(1, 3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Looks like we have to get them\nto come to their senses...", french="On dirait que nous allons devoir\nles ramener à la raison...", german="Sieht fast so aus, als müssten\nwir sie wieder zur Vernunft bringen...", italian="Non ci rimane altra scelta\nche affrontarli...", spanish="Parece que vamos a tener que\nhacer que entren en razón..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Everyone, I'm counting on you!", french=" Je compte sur vous tous!", german=" Ich zähle auf euch alle!", italian=" Conto su di voi!", spanish=" ¡Cuento con todos vosotros!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(122, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
