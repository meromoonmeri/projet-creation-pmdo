-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P42A/n04a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=43, sub=5} -- $SCENARIO_SIDE = scn[43,5] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(161, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D57P42A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 232, 264, Direction.Up, "NPC_GOOSUTO")
  GROUND:MoveToPosition(npc_npc_goosuto, 228, 188, false, 2)
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "exclaim", 1) end)
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER_KIMAWARI)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wait! [CS:N]Haunter[CR]!", french=" Attends! [CS:N]Spectrum[CR]!", german=" Warte! [CS:N]Alpollo[CR]!", italian=" Aspetta! [CS:N]Haunter[CR]!", spanish=" ¡Alto ahí, [CS:N]Haunter[CR]!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_goosuto, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 228, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm going to apprehend you\nthis time![K] Believe me!", french="Je vais t'arrêter cette fois![K]\nTu peux me croire!", german="Dieses Mal werde ich dich\nfestnehmen![K] Glaub mir!", italian="Questa volta non mi sfuggirai![K]\nStanne certo!", spanish="Esta vez voy a detenerte.[K]\n¡Puedes estar seguro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Ugh![K] You again?!", french=" Hein![K] Encore toi?!", german=" Uff![K] Du schon wieder?!?", italian=" Urgh![K] Ancora tu?!", spanish=" ¡Uf![K] ¡¿Otra vez tú?!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="You're persistent![K] Have you\nforgotten that I'm invincible?!", french="Quelle obstination![K] Tu as déjà\noublié que j'étais invincible?!", german="Du bist ganz schön hartnäckig![K]\nHast du etwa schon vergessen, dass ich\nunbesiegbar bin?!?", italian="Sei davvero testarda![K] Ti sei\nforse scordata che sono invincibile?!", spanish="¡Qué pelmaza![K] ¡¿Es que ya\nse te ha olvidado que soy invencible?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Invincible or not,\nit doesn't matter!", french="Invincible ou pas,\npeu m'importe!", german="Unbesiegbar oder nicht, das ist\njetzt auch egal!", italian="Invincibile o meno, non mi\nimporta!", spanish="¡Me da igual que seas\ninvencible o no!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I am...[K] I am going to arrest you.\nIt's that simple!", french="Je vais...[K] je vais t'arrêter.\nC'est aussi simple que ça!", german="Ich werde...[K] Ich werde dich\nfestnehmen! So einfach ist das!", italian="Io...[K] io ti arresterò,\npunto e basta!", spanish="Voy...[K] Voy a arrestarte.\n¡Así de simple!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Humph!", french=" Humph!", german=" Hmpf!", italian=" Tzè!", spanish=" ¡Ja!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="I've seen explorers like\nyou before!", french="J'ai rencontré des explorateurs\nde ta trempe par le passé!", german="Erkunder wie dich habe ich\nschon viele gesehen.", italian="Ne ho già incontrati altri\ndi esploratori come te!", spanish="Ya he visto antes a exploradores\ncomo tú."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="The persistent explorers who\ntried to challenge me over and over again!", french="Des explorateurs entêtés qui ont\nessayé de me défier encore et encore!", german="Hartnäckige Erkunder, die mich\nwieder und wieder herausforderten!", italian="Esploratori testardi che non\nsmettevano mai di sfidarmi!", spanish="Los que insisten en retarme\nuna vez tras otra."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Big deal![K] It might be a huge\nshock, even for you, but--", french="La belle affaire![K] Ça pourrait te\nfaire un choc, même à toi, mais...", german="Keine wirkliche\nHerausforderung![K] Hmm... Das könnte jetzt ein\nharter Schlag für dich sein...", italian="Apri bene le orecchie![K] Forse\nsarà un grande shock per te, ma...", spanish="¡A mí me resbala![K] Igual te pilla\npor sorpresa, porque no te enteras, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="It doesn't matter how\nhard you try...", french=" ... tu auras beau essayer...", german="Aber es ist wirklich egal, wie\nsehr du es auch probierst...", italian=" ... per quanti sforzi tu faccia...", spanish=" Por mucho que lo intentes..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="There is no way you can\nsucceed![K] No possible way!", french="... tu n'as aucune chance\nde parvenir à tes fins![K] Aucune!", german="Es gibt keinen Weg, mich zu\nbesiegen![K] Absolut keinen Weg!", italian="... non riuscirai mai a battermi![K]\nMai!", spanish="No hay forma de que me\nganes.[K] ¡De ningún modo!"})
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
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" So let's go!", french=" Alors en garde!", german=" Also bringen wir es hinter uns!", italian=" Dai, fatti sotto!", spanish=" ¡Así que vamos allá!"})
  -- message_Close
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(161, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
